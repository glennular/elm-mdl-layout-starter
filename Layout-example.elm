module LayoutExample exposing (..)

import Html exposing (..)
import Material
import Material.Color as Color
import Material.Icon as Icon
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Material.Layout as Layout
import Material.Options as Options exposing (css)
import Material.Scheme
import Material.Typography as Typography

type alias Mdl =
    Material.Model

-- MODEL

type alias Model =
    { message : String
    , appName : String
    , tabName : String
    , color : Color.Hue
    , mdl : Mdl
    }

model : Model
model =
    { message = "Hello World"
    , appName = "Sample"
    , tabName = "Tab1"
    , color = Color.Indigo
    , mdl = Material.model
    }

-- UPDATE

type Msg
    = Mdl (Material.Msg Msg)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

-- VIEW

layout : Model -> Html Msg
layout model =
    Material.Scheme.top <|
        Layout.render Mdl
                model.mdl
                [ Layout.fixedHeader ]
                { header = [ header model ]
                , drawer = drawer model
                , tabs = ( tabs model, [Color.background (Color.color model.color Color.S400)])
                , main = [ body model ]
                }


body : Model -> Html Msg
body model =
    let
         title : Grid.Cell Msg
         title =
            cell [ size Desktop 12, size Tablet 8, size Phone 4 ]
                [ Options.styled div
                    [ Typography.left, Typography.display3 ]
                    [ text model.tabName ]
                ]

         boxed : List (Options.Property a b)
         boxed =
                [ css "margin" "auto"
                , css "padding-left" "8%"
                , css "padding-right" "8%"
                ]

         body : String
         body = String.repeat 30 "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse at justo augue. "

         bodyCells : List (Grid.Cell Msg)
         bodyCells =
            cell [ size Desktop 6, size Tablet 8, size Phone 4 ]
              [ Options.styled div [] [ text body ] ]
            |> List.repeat 3

     in
         grid boxed
          (title :: bodyCells)

body2 : Model -> Html Msg
body2 model =
  grid [ Options.css "max-width" "1080px" ]
      [ cell
        [ size All 8 ]
        [ div [] [ text model.message]]
      ]

header : Model -> Html Msg
header model =
    Layout.row
        [ Color.background (Color.color model.color Color.S500)]
        [ Layout.title [] [ text model.appName ]
        , Layout.spacer
        , Layout.navigation []
                [ Layout.link [ ] [ Icon.i "photo" ]
                , Layout.link []  [ text "link 2" ]
                , Layout.link []  [ text "link 3" ]]
        ]

drawer : Model -> List (Html Msg)
drawer model =
    [ Layout.title [] [ text model.appName ]
    , Layout.navigation
        []
        [ Layout.link [] [ text "link 1" ]
        , Layout.link [] [ text "link 2" ]
        , Layout.link [] [ text "link 3" ]
        ]
    ]

tabs : Model ->  List (Html Msg)
tabs model =
      [ text "Tab1"
      , text "Tab2"
      , text "Tab3"
      ]

-- MAIN

main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = layout
        , subscriptions = always Sub.none
        , update = update
        }
