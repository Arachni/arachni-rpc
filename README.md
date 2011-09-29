# Arachni-RPC
<table>
    <tr>
        <th>Version</th>
        <td>0.1</td>
    </tr>
    <tr>
        <th>Github page</th>
        <td><a href="http://github.com/Arachni/arachni-rpc">http://github.com/Arachni/arachni-rpc</a></td>
     <tr/>
    <tr>
        <th>Code Documentation</th>
        <td><a href="http://rubydoc.info/github/Arachni/arachni-rpc/">http://rubydoc.info/github/Arachni/arachni-rpc/</a></td>
    </tr>
    <tr>
       <th>Author</th>
       <td><a href="mailto:tasos.laskos@gmail.com">Tasos</a> "<a href="mailto:zapotek@segfault.gr">Zapotek</a>" <a href="mailto:tasos.laskos@gmail.com">Laskos</a></td>
    </tr>
    <tr>
        <th>Twitter</th>
        <td><a href="http://twitter.com/Zap0tek">@Zap0tek</a></td>
    </tr>
    <tr>
        <th>Copyright</th>
        <td>2011</td>
    </tr>
    <tr>
        <th>License</th>
        <td><a href="file.LICENSE.html">GNU General Public License v2</a></td>
    </tr>
</table>

## Synopsis

Arachni-RPC is a simple and lightweight EventMachine based RPC client and server implementation. <br/>
It is under development and will ultimately provide the basis for <a href="http://arachni.segfault.gr">Arachni</a>'s Grid infrastructure.

## Features

It's capable of:

 - performing and handling a few thousand requests per second (depending on call size, network conditions and the like)
 - TLS encrytion (with peer verification)
 - asynchronous and synchronous requests
 - handling server-side asynchronous calls that require a block (or any method that requires a block in general)

## Usage

Check out the files in the <i>examples/</i> directory, they go through everything in great detail.<br/>
The tests under <i>spec/arachni/rpc/</i> cover everything too so they can probably help you out.

## Installation

### Gem

The Gem hasn't been pushed yet, the system is still under development.

### Source

If you want to clone the repository and work with the source code:

    git co git://github.com/arachni/arachni-rpc.git
    cd arachni-rpc
    rake install


## Running the Specs

In order to run the specs you must first fire up 2 sample servers like so:

    ruby spec/servers/basic.rb
    ruby spec/servers/with_ssl_primitives.rb

Then:

    rake spec

## Bug reports/Feature requests
Please send your feedback using Github's issue system at
[http://github.com/arachni/arachni-rpc/issues](http://github.com/arachni/arachni-rpc/issues).


## License
Arachni is licensed under the GNU General Public License v2.<br/>
See the [LICENSE](file.LICENSE.html) file for more information.

