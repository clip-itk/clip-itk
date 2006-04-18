#define EG_NOPARSER		108

#define XML_PARAM_ENTITY_PARSING_NEVER				0
#define XML_PARAM_ENTITY_PARSING_UNLESS_STANDALONE	1
#define XML_PARAM_ENTITY_PARSING_ALWAYS				2

/* Error code */
#define XML_ERROR_NONE                             0
#define XML_ERROR_NO_MEMORY                        1
#define XML_ERROR_SYNTAX                           2
#define XML_ERROR_NO_ELEMENTS                      3
#define XML_ERROR_INVALID_TOKEN                    4
#define XML_ERROR_UNCLOSED_TOKEN                   5
#define XML_ERROR_PARTIAL_CHAR                     6
#define XML_ERROR_TAG_MISMATCH                     7
#define XML_ERROR_DUPLICATE_ATTRIBUTE              8
#define XML_ERROR_JUNK_AFTER_DOC_ELEMENT           9
#define XML_ERROR_PARAM_ENTITY_REF                 10
#define XML_ERROR_UNDEFINED_ENTITY                 11
#define XML_ERROR_RECURSIVE_ENTITY_REF             12
#define XML_ERROR_ASYNC_ENTITY                     13
#define XML_ERROR_BAD_CHAR_REF                     14
#define XML_ERROR_BINARY_ENTITY_REF                15
#define XML_ERROR_ATTRIBUTE_EXTERNAL_ENTITY_REF    16
#define XML_ERROR_MISPLACED_XML_PI                 17
#define XML_ERROR_UNKNOWN_ENCODING                 18
#define XML_ERROR_INCORRECT_ENCODING               19
#define XML_ERROR_UNCLOSED_CDATA_SECTION           20
#define XML_ERROR_EXTERNAL_ENTITY_HANDLING         21
#define XML_ERROR_NOT_STANDALONE                   22
#define XML_ERROR_UNEXPECTED_STATE                 23
#define XML_ERROR_ENTITY_DECLARED_IN_PE            24
#define XML_ERROR_FEATURE_REQUIRES_XML_DTD         25
#define XML_ERROR_CANT_CHANGE_FEATURE_ONCE_PARSING 26
		/* Added in 1.95.7. */
#define XML_ERROR_UNBOUND_PREFIX                   27
		/* Added in 1.95.8. */
#define XML_ERROR_UNDECLARING_PREFIX               28
#define XML_ERROR_INCOMPLETE_PE                    29
#define XML_ERROR_XML_DECL                         30
#define XML_ERROR_TEXT_DECL                        31
#define XML_ERROR_PUBLICID                         32
#define XML_ERROR_SUSPENDED                        33
#define XML_ERROR_NOT_SUSPENDED                    34
#define XML_ERROR_ABORTED                          35
#define XML_ERROR_FINISHED                         36
#define XML_ERROR_SUSPEND_PE                       37


