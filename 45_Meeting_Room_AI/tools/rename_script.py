import os

project_dir = '45_Meeting_Room_AI/lib'

replacements = {
    'Shoe Room AI': 'Meeting Room AI',
    'ShoeRoomAI': 'MeetingRoomAI',
    'ShoeAI': 'MeetingAI',
    'ShoeResult': 'MeetingResult',
    'shoe_result': 'meeting_result',
    'ShoeResultStorage': 'MeetingResultStorage',
    'LaundryHistoryRepository': 'MeetingHistoryRepository',
    'LaundryPromptBuilder': 'MeetingPromptBuilder',
    'ShoeAIConfig': 'MeetingAIConfig',
    'ShoeAIText': 'MeetingRoomText',
    'ShoeAIColors': 'MeetingRoomColors',
    'ShoeAISpacing': 'MeetingRoomSpacing',
    'shoe_room_ai_theme.dart': 'meeting_room_theme.dart',
    'shoe_ai_config.dart': 'meeting_ai_config.dart',
    'shoe_result_storage.dart': 'meeting_result_storage.dart',
    'laundry_history_repository.dart': 'meeting_history_repository.dart',
    'laundry_prompt_builder.dart': 'meeting_prompt_builder.dart',
    'package:shoe_room_ai': 'package:meeting_room_ai',
}

for root, dirs, files in os.walk(project_dir):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r') as f:
                content = f.read()

            new_content = content
            for old, new in replacements.items():
                new_content = new_content.replace(old, new)

            if new_content != content:
                print(f"Updating {filepath}")
                with open(filepath, 'w') as f:
                    f.write(new_content)
