import os

def replace_imports(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        new_content = content.replace('rooftop_config.dart', 'apartment_config.dart')
        new_content = new_content.replace('rooftop_result_storage.dart', 'apartment_result_storage.dart')
        new_content = new_content.replace('rooftop_history_repository.dart', 'apartment_history_repository.dart')
        new_content = new_content.replace('rooftop_prompt_builder.dart', 'apartment_prompt_builder.dart')

        if content != new_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Fixed imports in: {filepath}")
    except Exception as e:
        print(f"Error reading {filepath}: {e}")

def main():
    target_dir = '41_Small_Apartment_Studio'
    for root, dirs, files in os.walk(target_dir):
        for file in files:
            if file.endswith('.dart'):
                replace_imports(os.path.join(root, file))

if __name__ == '__main__':
    main()
