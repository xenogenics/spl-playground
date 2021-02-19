# SPL application playground

This repository contains some basic examples of what can be achieve with the [SPL](https://www.ibm.com/support/knowledgecenter/SSCRJU_4.3.0/com.ibm.streams.ref.doc/doc/spl-container.html)
programming languages and the [Streams](https://github.com/IBMStreams/OSStreams) runtime.

## Getting started

### Grabbing a runtime image for Streams

You need to [build it](https://github.com/IBMStreams/OSStreams) and push it in your own registry. The `Makefile` assume
`localhost:5000` as the default registry, and `$USER` as the default namespace.

### Build the applications
```bash
$ make
```
## License

See the `LICENSE` file.
