module Main exposing (..)

import Html exposing (Html, text, div, h1, img, canvas)
import Html.Attributes exposing (src, width, height, id)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Encode
import Json.Decode
import Json.Decode.Pipeline
import Dict


---- CONSTANTS ----


socketServer : String
socketServer =
    "ws://localhost:4000/socket/websocket"



---- MODEL ----
{-
   In Elm applications, the model is responsible for containing the app state.
   The `initialModel`, passed to `init`, is our applications starting state.
-}


type alias Line =
    { color : String
    , from : LineFrom
    , to : LineTo
    }


type alias LineFrom =
    { x : Int
    , y : Int
    }


type alias LineTo =
    { x : Int
    , y : Int
    }


type alias Model =
    { lines : List Line
    , phxSocket : Phoenix.Socket.Socket Msg
    }


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on "draw" "rooms:lobby" ReceiveDrawing


initialModel : Model
initialModel =
    { lines = []
    , phxSocket = initPhxSocket
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


decodeLine : Json.Decode.Decoder Line
decodeLine =
    Json.Decode.Pipeline.decode Line
        |> Json.Decode.Pipeline.required "color" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "from" (decodeLineFrom)
        |> Json.Decode.Pipeline.required "to" (decodeLineTo)


decodeLineFrom : Json.Decode.Decoder LineFrom
decodeLineFrom =
    Json.Decode.Pipeline.decode LineFrom
        |> Json.Decode.Pipeline.required "x" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "y" (Json.Decode.int)


decodeLineTo : Json.Decode.Decoder LineTo
decodeLineTo =
    Json.Decode.Pipeline.decode LineTo
        |> Json.Decode.Pipeline.required "x" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "y" (Json.Decode.int)


encodeLine : Line -> Json.Encode.Value
encodeLine record =
    Json.Encode.object
        [ ( "color", Json.Encode.string <| record.color )
        , ( "from", encodeLineFrom <| record.from )
        , ( "to", encodeLineTo <| record.to )
        ]


encodeLineFrom : LineFrom -> Json.Encode.Value
encodeLineFrom record =
    Json.Encode.object
        [ ( "x", Json.Encode.int <| record.x )
        , ( "y", Json.Encode.int <| record.y )
        ]


encodeLineTo : LineTo -> Json.Encode.Value
encodeLineTo record =
    Json.Encode.object
        [ ( "x", Json.Encode.int <| record.x )
        , ( "y", Json.Encode.int <| record.y )
        ]



---- UPDATE ----


userParams : Json.Encode.Value
userParams =
    Json.Encode.object [ ( "canvas_id", Json.Encode.string "123" ) ]


type Msg
    = PhoenixMsg (Phoenix.Socket.Msg Msg)
    | JoinChannel
    | LeaveChannel
    | ReceiveDrawing Json.Encode.Value
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        JoinChannel ->
            let
                channel =
                    Phoenix.Channel.init "rooms:lobby"
                        |> Phoenix.Channel.withPayload userParams

                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.join channel model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        LeaveChannel ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.leave "rooms:lobby" model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        ReceiveDrawing raw ->
            case Json.Decode.decodeValue decodeLine raw of
                Ok drawing ->
                    ( { model | lines = (drawing) :: model.lines }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ canvas [ width 300, height 300, id "elm-canvas" ] []
        ]



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.Socket.listen model.phxSocket PhoenixMsg



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
