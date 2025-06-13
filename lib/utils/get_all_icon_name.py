import re

# 读取 Dart 文件内容
with open('icomoon.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# 使用正则表达式提取 IconData 字段名
matches = re.findall(r'static const IconData (\w+)\s*=', content)

# 输出形式 Icomoon.xxx
for name in matches:
    print(f'Icomoon.{name},')