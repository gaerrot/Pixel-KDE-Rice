import sys

condition = sys.argv[1].lower()

ICON_SUN    = chr(0xf185)   # already confirmed working (used for brightness icon)
ICON_CLOUD  = chr(0x2601)   # basic Unicode cloud
ICON_RAIN   = chr(0x2602)   # basic Unicode umbrella
ICON_SNOW   = chr(0x2744)   # basic Unicode snowflake
ICON_STORM  = chr(0xf0e7)   # FontAwesome bolt/flash

if "thunder" in condition or "storm" in condition:
    icon = ICON_STORM
elif "snow" in condition or "sleet" in condition or "ice" in condition:
    icon = ICON_SNOW
elif "rain" in condition or "drizzle" in condition or "shower" in condition:
    icon = ICON_RAIN
elif "cloud" in condition or "overcast" in condition:
    icon = ICON_CLOUD
elif "sun" in condition or "clear" in condition:
    icon = ICON_SUN
else:
    icon = ICON_CLOUD

print(icon)
