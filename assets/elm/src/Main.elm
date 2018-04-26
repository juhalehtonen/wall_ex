module Main exposing (..)

import Html exposing (Html, text, div, h1, img, canvas)
import Html.Attributes exposing (src, width, height, id)


---- MODEL ----


type alias Drawing =
    { from : Int, to : Int, color : String }


type alias Model =
    { drawings : List Drawing }



-- The initial model where our application starts from.


initialModel : Model
initialModel =
    { drawings = []
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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
    Sub.none



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
