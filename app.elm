
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  {counter : Int}

init : (Model, Cmd Msg)
init =
  (Model 0, Cmd.none)

-- UPDATE

type Msg 
  = Get
  | GetCounter (Result Http.Error Int)
  | Reset
  | ResetCounter (Result Http.Error Int)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Get ->
      (model, getServerCounter)

    GetCounter (Ok newCounter) ->
      ( { model | counter = newCounter }, Cmd.none )

    GetCounter (Err _) ->
      (model, Cmd.none)

    Reset ->
    (model, resetServerCounter)

    ResetCounter (Ok newCounter) ->
      ( { model | counter = newCounter }, Cmd.none )

    ResetCounter (Err _) ->
      (model, Cmd.none)



-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text (toString model.counter)]
    , button [onClick Get] [text "Get"]
    , button [onClick Reset] [text "Reset"]
    ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP

getServerCounter : Cmd Msg
getServerCounter =
  let
    url = "http://localhost:3000/counter"

    request =
      Http.get url decodeCounter
  in
    Http.send GetCounter request


resetServerCounter : Cmd Msg
resetServerCounter =
  let 
    url = "http://localhost:3000/counter/1"

    request = Http.post url Http.emptyBody decodeCounter

  in
    Http.send ResetCounter request


decodeCounter : Decode.Decoder Int
decodeCounter =
  Decode.at ["counter"] Decode.int
