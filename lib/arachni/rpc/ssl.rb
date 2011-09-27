=begin
Arachni-RPC
Copyright (c) 2011 Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>

This is free software; you can copy and distribute and modify
this program under the term of the GPL v2.0 License
(See LICENSE file for details)

=end

require File.join( File.expand_path( File.dirname( __FILE__ ) ), '../', 'rpc' )

require 'openssl'
require 'tempfile'
# require 'ap'

#
# Adds support for a few helper methods to X509 certs.
#
# @see https://gist.github.com/1151454
#
class OpenSSL::X509::Certificate

    def ==( other )
        other.respond_to?( :to_pem ) && to_pem == other.to_pem
    end

    # A serial *must* be unique for each certificate. Self-signed certificates,
    # and thus root CA certificates, have the same `issuer' as `subject'.
    def top_level?
        serial == serial && issuer.to_s == subject.to_s
    end

    alias_method :root?, :top_level?
    alias_method :self_signed?, :top_level?
end

module Arachni
module RPC

#
# Adds support for SSL and peer verification.
#
# To be included by EventMachine::Connection classes.
#
# @see https://gist.github.com/1151454
#
# @author: Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: 0.1
#
module SSL

    include ::Arachni::RPC::ConnectionUtilities

    #
    # Starts SSL with the supplied keys, certs etc.
    #
    def start_ssl

        ssl_opts = {}
        if ssl_opts?

            # @@cert_chain_file ||= merge_key_with_cert( @server.opts[:ssl_pkey],
                # @server.opts[:ssl_cert] )

            ssl_opts = {
                    :private_key_file => @server.opts[:ssl_pkey],
                    :cert_chain_file  => @server.opts[:ssl_cert],
                    :verify_peer      => true
                }

            @last_seen_cert = nil
        end

        # ap ssl_opts
        start_tls( ssl_opts )
    end

    #
    # Cleans up any SSL related resources.
    #
    def end_ssl
    end

    #
    # To be implemented by the parent.
    #
    # @return   [String] IP address of the peer
    #
    def peer_ip_addr
        'n/a'
    end

    #
    # To be implemented by the parent.
    #
    # By default, it will 'warn' if the severity is :error and will 'raise'
    # if the severity if :fatal.
    #
    # @param    [Symbol]    severity    :fatal, :error, :warn, :info, :debug
    # @param    [String]    progname    name of the component that performed the action
    # @param    [String]    msg         message to log
    #
    def log( severity, progname, msg )
        warn "#{progname}: #{msg}" if severity == :error
        raise "#{progname}: #{msg}" if severity == :fatal
    end

    # def merge_key_with_cert( key, cert )
        # cert_chain_file = Tempfile.new( 'key+cert.pem' )
#
        # begin
            # cert_chain_file.write( File.read( key ) + "\n" )
            # cert_chain_file.write( File.read( cert) )
#
            # return cert_chain_file.path
        # ensure
            # cert_chain_file.close
        # end
    # end

    #
    # @return   [OpenSSL::X509::Store]  certificate store
    #
    def ca_store
        if !@ca_store
            if file = @server.opts[:ssl_ca]
                @ca_store = OpenSSL::X509::Store.new
                @ca_store.add_file( file )
            else
                raise "No CA certificate has been provided."
            end
        end

        return @ca_store
    end

    #
    # Verifies the peer cert based on the {#ca_store}.
    #
    # @see http://eventmachine.rubyforge.org/EventMachine/Connection.html#M000271
    #
    def ssl_verify_peer( cert_string )

        cert = OpenSSL::X509::Certificate.new( cert_string )

        # Some servers send the same certificate multiple times. I'm not even
        # joking... (gmail.com)
        return true if cert == @last_seen_cert

        if ca_store.verify( cert )
            @last_seen_cert = cert

            # A server may send the root certifiacte, which we already have and thus
            # should not be added to the store again.
            ca_store.add_cert( @last_seen_cert ) if !@last_seen_cert.root?

            return true
        else
            log( :error, 'SSL',
                "#{ca_store.error_string.capitalize} ['#{peer_ip_addr}']."
            )
            return false
        end
    end

    #
    # Checks for an appropriate server cert hostname if run from the client-side.
    #
    # Does nothing when on the server-side.
    #
    # @see http://eventmachine.rubyforge.org/EventMachine/Connection.html#M000270
    #
    def ssl_handshake_completed
        if are_we_a_client? && ssl_opts? &&
           !OpenSSL::SSL.verify_certificate_identity( @last_seen_cert,
                @server.opts[:host] )

            log( :error, 'SSL',
                "The hostname '#{@server.opts[:host]}' " +
                "does not match the server certificate."
            )

            connection_close
        end
    end

    def are_we_a_client?
        @server.opts[:role] == :client
    end

    def ssl_opts?
        @server.opts[:ssl_ca] && @server.opts[:ssl_pkey] && @server.opts[:ssl_cert]
    end

end
end
end
