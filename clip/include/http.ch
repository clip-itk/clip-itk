#ifndef __HTTP_CH__
#define __HTTP_CH__

#define KAMACHE_VERSION  0.10
#define KAMACHE_DEFPORT  3001
#define HTTP_DEFPORT	 80
#define HTTP_PROXYPORT   8080

#define HTTP_ERR_BADREQUEST                           400
#define HTTP_ERR_UNAUTHORIZED                         401
#define HTTP_ERR_PAYMENTREQUIRED                      402
#define HTTP_ERR_FORBIDDEN                            403
#define HTTP_ERR_FILENOTFOUND                         404
#define HTTP_ERR_METHODNOTALLOWED                     405
#define HTTP_ERR_NOTACCEPTABLE                        406
#define HTTP_ERR_PROXYAUTHREQUIRED                    407
#define HTTP_ERR_REQUESTTIMEOUT                       408
#define HTTP_ERR_CONFLICT                             409
#define HTTP_ERR_GONE                                 410
#define HTTP_ERR_LENGTHREQUIRED                       411
#define HTTP_ERR_PRECONDITIONFAILED                   412
#define HTTP_ERR_REQUESTENTITYTOOLARGE                413
#define HTTP_ERR_REQUESTURITOOLONG                    414
#define HTTP_ERR_UNSUPPORTEDMEDIATYPE                 415
#define HTTP_ERR_REQUESTEDRANGENOTSATISFIABLE         416
#define HTTP_ERR_EXPECTATIONFAILED                    417

#define HTTP_ERR_INTERNALSERVERERROR                  500
#define HTTP_ERR_NOTIMPLEEMENTED                      501
#define HTTP_ERR_BADGATEWAY                           502
#define HTTP_ERR_SERVICEUNAVAILABLE                   503
#define HTTP_ERR_GATEWAYTIMEOUT                       504
#define HTTP_ERR_BADVERSION                           505

#endif
