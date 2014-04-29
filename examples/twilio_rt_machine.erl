%%%-------------------------------------------------------------------
%%% @author Ryan Huffman <ryanhuffman@gmail.com>
%%% @copyright 2011, Ryan Huffman modified by Joey Erskine 
%%% @doc Twilio machine.
%%%
%%% @end
%%% Created : 10 Jul 2011
%%%-------------------------------------------------------------------
-module(twilio_rt_machine).  %%module basic unites of code in erlang, loads functions from twilio. 

-export([handle_request/2]). %%list of functions exported from the module, /2 denotes two arguements

-include("twilio.hrl"). %%include twilio file.

%% @doc Handle incoming twilio requests on "/machine".
handle_request(["options"], _Params) ->
    [
        #gather{
            action="selected_option", %%where to send
            timeout=2,
            body=[
                #say{text=
                    "Press 1 if you are a senior."
                    "Press 2 if you are a junior."
                }
            ]}
    ];
handle_request(["selected_option"], Params) ->
    Digits = proplists:get_value("Digits", Params), %%property list
    case Digits of
        "1" ->
            [
                #say{text="Congrats, no final for you."},
                #redirect{url="options"}
            ];
        "2" ->
            [
                #say{text="Sorry, both Joe Kromrey and you have to take the final."},
                #redirect{url="options"}
            ];
        _ ->
            [
                #say{text="Sorry, that is an invalid option"},
                #redirect{url="options"}
            ]
    end.

