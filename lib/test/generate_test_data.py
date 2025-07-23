import random
from datetime import datetime, timedelta, UTC

def random_date(start_year=1500):
    start_date = datetime(start_year, 1, 1, tzinfo=UTC)
    end_date = datetime.now(UTC)

    delta_days = (end_date - start_date).days
    random_days = random.randint(0, delta_days)
    random_date = start_date + timedelta(days=random_days)

    return f'DateTime({random_date.year}, {random_date.month}, {random_date.day})'

def generate_usage_records(count=100000, item_id=1):
    lines = []
    for i in range(count):
        used_at = random_date()
        line = f'UsageRecordModel(id: {i+100}, itemId: {item_id}, usedAt: {used_at}),'
        lines.append(line)
    return lines

if __name__ == "__main__":
    records = generate_usage_records()
    print("import '../models/usage_record_model.dart';\n")
    print('final testRecords = <UsageRecordModel>[')
    for record in records:
        print(f'  {record}')
    print('];')
