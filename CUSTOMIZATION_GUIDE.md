# Task Customization Guide

## How to change task names

### Method 1: Via Garmin Connect Mobile (recommended)
1. Open Garmin Connect Mobile app
2. Go to: **Devices** → **Your Device** → **Connect IQ Apps**
3. Find **Garmodoro** → **Settings**
4. Change "Slot X: Name" to your desired name
5. Sync watch with phone

### Method 2: Edit properties.xml directly
1. Open `resources/settings/properties.xml`
2. Find `<property id="task1_name" type="string">State</property>`
3. Change "State" to your desired name
4. Rebuild and reinstall app

## Task to Activity Type Mapping

| Task | Sport Code | SubSport Code | Garmin Activity |
|------|------------|---------------|-----------------|
| State | 0 | 43 | Generic / Yoga |
| Comfort | 10 | 26 | Fitness Equipment / Cardio Training |
| Care | 0 | 48 | Generic / Commuting |
| Work | 0 | 39 | Generic / eSports |
| Growth | 4 | 0 | Training / Strength Training |

### Understanding Sport and SubSport Codes

Garmin uses a combination of sport and subsport codes to categorize activities. These codes determine how the activity appears in Garmin Connect and how data is processed.

- **Sport Code**: Main activity category (0=Generic, 4=Training, 10=Fitness Equipment, etc.)
- **SubSport Code**: Specific activity type within the sport category

## Adding/Removing Tasks

### Enable/Disable via Garmin Connect Mobile:
1. Open GCM → Device → Connect IQ Apps → Garmodoro → Settings
2. Toggle "Slot X: Enabled" to enable/disable specific tasks
3. Disabled tasks won't appear in the task selection menu

### Add new slot (requires code change):
1. Add new properties in `resources/settings/properties.xml`:
   ```xml
   <property id="task6_enabled" type="boolean">true</property>
   <property id="task6_name" type="string">NewTask</property>
   <property id="task6_sport" type="number">0</property>
   <property id="task6_subsport" type="number">0</property>
   ```

2. Add settings group in `resources/settings/settings.xml`:
   ```xml
   <setting propertyKey="@Properties.task6_enabled" title="Slot 6: Enabled">
       <settingConfig type="boolean" />
   </setting>
   <setting propertyKey="@Properties.task6_name" title="Slot 6: Name">
       <settingConfig type="alphaNumeric" />
   </setting>
   <setting propertyKey="@Properties.task6_subsport" title="Slot 6: Activity Code">
       <settingConfig type="numeric" min="0" max="100" />
   </setting>
   ```

3. Increase MAX_SLOTS in `source/TaskMenuBuilder.mc`:
   ```monkey
   const MAX_SLOTS = 6;  // Changed from 5 to 6
   ```

## Common Sport/SubSport Code Combinations

Here are some useful combinations you might want to use:

| Activity | Sport | SubSport | Description |
|----------|-------|----------|-------------|
| Running | 1 | 0 | General running |
| Cycling | 2 | 0 | General cycling |
| Strength Training | 4 | 0 | Strength/resistance training |
| Yoga | 0 | 43 | Yoga session |
| Meditation | 0 | 45 | Meditation |
| Cardio | 10 | 26 | Cardio training |
| Walking | 11 | 0 | Walking |
| Other | 0 | 0 | Generic activity |

## Troubleshooting

### Task menu doesn't appear
- Ensure at least one task slot is enabled in settings
- Check that minSdkVersion in manifest.xml is 3.2.0 or higher
- Verify the app has been rebuilt after changes

### Activities not syncing to Garmin Connect
- Ensure GPS is not required for the activity type
- Check that sport and subsport codes are valid
- Verify device is connected to Garmin Connect Mobile

### Task names not updating
- Make sure you've synced the watch after changing settings in GCM
- Try forcing a sync from the Garmin Connect Mobile app
- Rebuild and reinstall if you edited properties.xml directly
