=begin
                  Arachni-RPC
  Copyright (c) 2011 Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LICENSE file for details)

=end

require File.join( File.expand_path( File.dirname( __FILE__ ) ), '../', 'rpc' )

module Arachni
module RPC

#
# Represents an RPC request.
#
# It's here only for formalization purposes,
# it's not actually sent over the wire.
#
# What is sent is a hash generated by {#prepare_for_tx}.
# which is in the form of:
#
#
#    {
#        'message'     => msg, # RPC message in the form of 'handler.method'
#        'args'        => args, # optional array of arguments for the remote method
#        'token'       => token, # optional authentication token,
#
#        # optional unique identifier for the callback
#        # (helper field, included in the response)
#        'callback_id' => callback_id
#    }
#
# Any client that has SSL support and can serialize a Hash
# just like the one above can communicate with the RPC server.
#
# @author: Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: 0.1
#
class Request < Message

    #
    # RPC message in the form of 'handler.method'.
    #
    # @return   [String]
    #
    attr_accessor :message

    #
    # Optional array of arguments for the remote method.
    #
    # @return   [Array]
    #
    attr_accessor :args

    #
    # Optional authentication token.
    #
    # @return   [String]
    #
    attr_accessor :token

    #
    # Callback to be invoked on the response.
    #
    # @return   [Proc]
    #
    attr_accessor :callback

    # @see Message#initialize
    def initialize( * )
        super
        @defer = true
    end

    def do_not_defer!
        @defer = false
    end

    def defer?
        @defer
    end

    private

    def transmit?( attr )
        ![
            :@defer,
            :@callback
        ].include?( attr )
    end

end

end
end
