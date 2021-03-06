-module(eepp_transport).
-behaviour(gen_server).
-define(SERVER, ?MODULE).
-define(HEADER_SIZE, 4).
-record(state, {socket}).
%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0, post/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

post(Msg) ->
    gen_server:call(?SERVER, {post, Msg}).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([]) ->
    {ok, Socket} = ssl:connect(
        eepp_config:get(host), eepp_config:get(port), [
        binary,
        {exit_on_close, true},
        {active, false},
        {keepalive, true},
        {certfile, eepp_config:get(certfile)},
        {keyfile, eepp_config:get(keyfile)}
        ]),    
    {ok, #state{socket=Socket},0}.

handle_call({post, Msg}, _From, State) ->
    ok = send(State#state.socket, Msg),
    {ok, Response} = recv(State#state.socket),
    {reply, {ok, Response}, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(timeout, State) ->
    io:format("In timeout"),
    {ok, Greeting} = recv(State#state.socket),
    io:format("Greeting: ~p", [Greeting]),
    {noreply, State};
handle_info(Other, State) ->
    io:format("Received: ~p~n", [Other]),
    {noreply, State}.

terminate(_Reason, State) ->
    ssl:close(State#state.socket).

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

send(Socket, Msg) ->
    Length = string:len(Msg) + ?HEADER_SIZE,
    Data = <<Length:32, (list_to_binary(Msg))/binary>>,
    ok = ssl:send(Socket, Data),
    case eepp_config:get(debug) of
        true -> io:format("Message sent: ~n~s~n", [Msg]);
	   false -> ok
    end,
    ok.

recv(Socket) ->
    {ok, <<Length:32/integer>>} = ssl:recv(Socket, ?HEADER_SIZE),
    {ok, Data} = ssl:recv(Socket, Length-?HEADER_SIZE),
    Response = binary_to_list(Data),
    case eepp_config:get(debug) of
        true -> io:format(Response);
        false -> ok
    end,
    {ok, Data}.
