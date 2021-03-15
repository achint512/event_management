### Assumptions
```text
1. The format of CSV files for both user and events would not change.
2. In users.csv, the username, phone and email all already sanitised and system would not check whether their validity.
3. User email shall be unique.
4. end_datetime of an event cannot be less than start_datetime. If such data found, it would not be inserted into DB.
5. Event will be marked as completed on creation/updation of record if end_datetime is less than current time (Time.zone.now). There is no cron running in backgroud to automatically update events.
6. If event is marked as all_day event, its end_datetime will be automatically update to that days midnight - 1second time, i.e 23:59:59.
7. No two events can have the same combination of title, start and end time.
8. Only three rsvp options are available, 'yes', 'no' and 'maybe'.
9. If a user has RSVP as 'Yes' for multiple events, then while seeding/updating DB, all previous incomplete events RSVP will be marked as 'No'.
9. The time zone is New Delhi.
10. Application security features like authentication, etc. have to be handled separately and not part of this implementation.
```

### System Requirements
- Ruby 2.6.3
- Rails 6.1.1
- MySQL

### To setup the project, use the following command:
```shell
bundle install
```

### To run rails console:
```shell
rails console
```

### To run rails server:
```shell
rails server
```

### To run tests, use the following command:
```shell
rspec spec
```

### Steps to seed data:
```text
1. Copy users.csv and events.csv to some place inside the event_management directory. Example: Copy paste both files to the /tmp directory.
2. Run rails console.
3. To seed Users:
```
```shell
User.seed_data('tmp/users.csv')
```
```text
4. To seed events:
```
```shell
Event.seed_data('tmp/events.csv')
```

### Step to access UI:
```text
1. Run rails server.
2. To view Events dashboard, go to: http://127.0.0.1:3000/admin/events
3. To view Users dashboard, go to: http://127.0.0.1:3000/admin/users
4. For more info, click on the respective highlighted id from the dashboard.
5. You can change RSVP for any user and also add new events.
```
