select from_msgs.stream_name from_stream,
from_msgs.type from_type,
to_msgs.stream_name to_stream,
to_msgs.type to_type,
to_msgs.global_position
from messages to_msgs
LEFT OUTER JOIN messages from_msgs on to_msgs.metadata->>'causationMessageStreamName' = from_msgs.stream_name AND to_msgs.metadata->>'causationMessageGlobalPosition' = ''||from_msgs.global_position
order by to_msgs.stream_name asc, to_msgs.global_position asc
