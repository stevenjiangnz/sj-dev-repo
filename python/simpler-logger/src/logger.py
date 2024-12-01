import time
import datetime
import sys

# Force output to be unbuffered
sys.stdout.reconfigure(line_buffering=True)

def log_message():
    while True:
        current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"[{current_time}] Hello! I'm still running - ok!", flush=True)
        time.sleep(3)  # Wait for 3 seconds

if __name__ == "__main__":
    print("Starting the logger...", flush=True)
    log_message()