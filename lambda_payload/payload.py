from file_1 import remove_spaces
from file_2 import remove_underscores
from file_3 import remove_dashes

import json


def lambda_handler(event, context):

    event = event["key_1"]

    old_event = event
    event = remove_spaces(event)
    event = remove_underscores(event)
    event = remove_dashes(event)
    return json.dumps(
        {"formatted_event": event, "unformatted_event": old_event}, indent=2
    )
