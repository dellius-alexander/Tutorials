# HTTP Status Codes


Here is a comprehensive table of HTTP status codes, including their 
use cases and details based on the MDN documentation:

| **Code**              | **Name**                        | **Description**                                                                                                                               |
|-----------------------|---------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| **1xx Informational** |                                 |                                                                                                                                               |
| 100                   | Continue                        | The server has received the request headers and the client should proceed to send the request body.                                           |
| 101                   | Switching Protocols             | The requester has asked the server to switch protocols, and the server has agreed to do so.                                                   |
| 102                   | Processing (WebDAV)             | The server has received the request and is processing it, but no response is available yet.                                                   |
| **2xx Success**       |                                 |                                                                                                                                               |
| 200                   | OK                              | Standard response for successful HTTP requests.                                                                                               |
| 201                   | Created                         | The request has been fulfilled, leading to the creation of a resource.                                                                        |
| 202                   | Accepted                        | The request has been accepted for processing, but the processing has not been completed.                                                      |
| 203                   | Non-Authoritative Information   | The request was successful but the enclosed payload has been modified from the origin server's 200 OK response by a transforming proxy.       |
| 204                   | No Content                      | The server successfully processed the request, and is not returning any content.                                                              |
| 205                   | Reset Content                   | The server successfully processed the request, and is asking the client to reset the document view.                                           |
| 206                   | Partial Content                 | The server is delivering only part of the resource due to a range header sent by the client.                                                  |
| 207                   | Multi-Status (WebDAV)           | Provides status for multiple independent operations (for WebDAV).                                                                             |
| 208                   | Already Reported (WebDAV)       | The members of a DAV binding have already been enumerated in a previous reply, and are not being included again.                              |
| 226                   | IM Used                         | The server has fulfilled a request for the resource and the response is a representation of the result of one or more instance-manipulations. |
| **3xx Redirection**   |                                 |                                                                                                                                               |
| 300                   | Multiple Choices                | Indicates multiple options for the resource that the client may follow.                                                                       |
| 301                   | Moved Permanently               | This and all future requests should be directed to the given URI.                                                                             |
| 302                   | Found                           | The resource has been temporarily moved to a different URI.                                                                                   |
| 303                   | See Other                       | The response to the request can be found under another URI using the GET method.                                                              |
| 304                   | Not Modified                    | Indicates that the resource has not been modified since the version specified by the request headers.                                         |
| 305                   | Use Proxy                       | The requested resource is only available through a proxy.                                                                                     |
| 306                   | Switch Proxy                    | No longer used. Originally meant for subsequent requests to use a specific proxy.                                                             |
| 307                   | Temporary Redirect              | The request should be repeated with another URI; however, future requests should still use the original URI.                                  |
| 308                   | Permanent Redirect              | The request and all future requests should be repeated using another URI.                                                                     |
| **4xx Client Errors** |                                 |                                                                                                                                               |
| 400                   | Bad Request                     | The server could not understand the request due to invalid syntax.                                                                            |
| 401                   | Unauthorized                    | The request lacks valid authentication credentials for the target resource.                                                                   |
| 402                   | Payment Required                | Reserved for future use. (Used for digital payment systems.)                                                                                  |
| 403                   | Forbidden                       | The client does not have access rights to the content; the server is refusing to give the requested resource.                                 |
| 404                   | Not Found                       | The server can not find the requested resource.                                                                                               |
| 405                   | Method Not Allowed              | The request method is known by the server but is not supported by the target resource.                                                        |
| 406                   | Not Acceptable                  | The server cannot produce a response matching the list of acceptable values defined in the request's headers.                                 |
| 407                   | Proxy Authentication Required   | The client must first authenticate itself with the proxy.                                                                                     |
| 408                   | Request Timeout                 | The server did not receive a complete request message within the time that it was prepared to wait.                                           |
| 409                   | Conflict                        | The request could not be completed due to a conflict with the current state of the target resource.                                           |
| 410                   | Gone                            | The resource requested is no longer available and will not be available again.                                                                |
| 411                   | Length Required                 | The server refuses to accept the request without a defined Content-Length header.                                                             |
| 412                   | Precondition Failed             | The server does not meet one of the preconditions that the requester put on the request.                                                      |
| 413                   | Payload Too Large               | The request entity is larger than limits defined by the server.                                                                               |
| 414                   | URI Too Long                    | The URI provided was too long for the server to process.                                                                                      |
| 415                   | Unsupported Media Type          | The media format of the requested data is not supported by the server.                                                                        |
| 416                   | Range Not Satisfiable           | The range specified by the Range header field in the request can't be fulfilled.                                                              |
| 417                   | Expectation Failed              | The server cannot meet the requirements of the Expect request-header field.                                                                   |
| 418                   | I'm a teapot                    | A playful response code from an April Fools' joke in 1998 ("I'm a teapot").                                                                   |
| 421                   | Misdirected Request             | The request was directed at a server that is not able to produce a response.                                                                  |
| 422                   | Unprocessable Entity (WebDAV)   | The request was well-formed but could not be followed due to semantic errors.                                                                 |
| 423                   | Locked (WebDAV)                 | The resource that is being accessed is locked.                                                                                                |
| 424                   | Failed Dependency (WebDAV)      | The request failed due to failure of a previous request.                                                                                      |
| 425                   | Too Early                       | The server is unwilling to risk processing a request that might be replayed.                                                                  |
| 426                   | Upgrade Required                | The client should switch to a different protocol.                                                                                             |
| 428                   | Precondition Required           | The server requires the request to be conditional to prevent the 'lost update' problem.                                                       |
| 429                   | Too Many Requests               | The user has sent too many requests in a given amount of time.                                                                                |
| 431                   | Request Header Fields Too Large | The server is unwilling to process the request because its header fields are too large.                                                       |
| 451                   | Unavailable For Legal Reasons   | The user requested a resource that is unavailable due to legal reasons, such as government censorship.                                        |
| **5xx Server Errors** |                                 |                                                                                                                                               |
| 500                   | Internal Server Error           | The server has encountered a situation it doesn't know how to handle.                                                                         |
| 501                   | Not Implemented                 | The request method is not supported by the server and cannot be handled.                                                                      |
| 502                   | Bad Gateway                     | The server, while acting as a gateway or proxy, received an invalid response from the upstream server.                                        |
| 503                   | Service Unavailable             | The server is not ready to handle the request.                                                                                                |
| 504                   | Gateway Timeout                 | The server, while acting as a gateway or proxy, did not get a response in time from the upstream server.                                      |
| 505                   | HTTP Version Not Supported      | The HTTP version used in the request is not supported by the server.                                                                          |
| 506                   | Variant Also Negotiates         | The server has an internal configuration error: the chosen variant resource is configured to engage in content negotiation itself.            |
| 507                   | Insufficient Storage (WebDAV)   | The server is unable to store the representation needed to complete the request.                                                              |
| 508                   | Loop Detected (WebDAV)          | The server detected an infinite loop while processing a request with WebDAV.                                                                  |
| 510                   | Not Extended                    | Further extensions to the request are required for the server to fulfill it.                                                                  |
| 511                   | Network Authentication Required | The client needs to authenticate to gain network access.                                                                                      |

For more details, check the [MDN documentation on HTTP status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)【16†source】.
