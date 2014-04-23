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
handle_request(["start"], Params) ->
    % these are values sent in from twilio
    City = proplists:get_value("ToCity", Params),   %%property list, 
    State = proplists:get_value("ToState", Params),
    [
        #say{text="Hello! Welcome to Creighton."},
        #say{text="It appears you are calling from " ++ City ++
            ", " ++ State},
        #redirect{url="options"}
    ];
handle_request(["options"], _Params) ->
    [
        #gather{
            action="selected_option",
            timeout=2,
            num_digits=2,
            body=[
                #say{text=
                    "Press 1 if you are a senior. "
                    "Press 2 if you are a junior. "
                    "Press 3 to found out facts about Dr.Reed. "
                    "Press 4 to end this call. "
                    "Press 0 to hear the options again. "
                }
            ]}
    ];
handle_request(["selected_option"], Params) ->
    Digits = proplists:get_value("Digits", Params),
    case Digits of
        "1" ->
            [
                #say{text="Congrats, no final for you. "},
                #redirect{url="options"}
            ];
        "2" ->
            [
                #say{text="Your final is on Tuesday, at 10pm. "},
                #redirect{url="options"}
            ];
        "3" ->
            BetterFastStronger =
            "Work It 
            Make It 
            Do It 
            Makes Us 

            Harder 
            Better 
            Faster 
            Stronger 

            More Than 
            Hour 
            Our 
            Never 

            Ever 
            After 
            Work is 
            Over 

            Work It 
            Make It 
            Do It 
            Makes Us 

            Harder 
            Better 
            Faster 
            Stronger 

            Work It Harder Make It Better 
            Do It Faster Makes Us stronger 
            More Than Ever Hour After 
            Our Work Is Never Over",
            [
                #say{text=BetterFastStronger},
                #pause{length=6},
                #say{text="Why are you still on the line?"}
            ];
        "4" ->
            [
                #say{text="Goodbye!"}
            ];
        "0" ->
            [
                #redirect{url="options"}
            ];
        "42" ->
            [
                #say{text="If you already know the Answer to "
                    "the Ultimate Question of Life, the Universe, and Everything, "
                    "why are you calling me?  Scram."}
            ];
        _ ->
            [
                #say{text="Sorry, that is an invalid option"},
                #redirect{url="options"}
            ]
    end.

