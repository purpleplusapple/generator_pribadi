import os

def replace_in_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        new_content = content.replace('rooftop_lounge_ai', 'small_apartment_studio')
        new_content = new_content.replace('Rooftop Lounge', 'Small Apartment Studio')
        new_content = new_content.replace('RooftopLoungeApp', 'SmallApartmentStudioApp')
        # Be careful with generic 'Rooftop' -> 'Apartment' to avoid breaking things,
        # but for class names it is usually desired.
        # specific renames for known classes based on memory/exploration
        new_content = new_content.replace('RooftopResultStorage', 'ApartmentResultStorage')
        new_content = new_content.replace('RooftopHistoryRepository', 'ApartmentHistoryRepository')
        new_content = new_content.replace('RooftopConfig', 'ApartmentConfig')

        if content != new_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Updated: {filepath}")
    except Exception as e:
        print(f"Error reading {filepath}: {e}")

def main():
    target_dir = '41_Small_Apartment_Studio'
    for root, dirs, files in os.walk(target_dir):
        for file in files:
            if file.endswith(('.dart', '.yaml', '.xml', '.plist', '.json')):
                replace_in_file(os.path.join(root, file))

if __name__ == '__main__':
    main()
