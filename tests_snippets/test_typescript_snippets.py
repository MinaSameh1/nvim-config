"""
This script opens a terminal and types the text I want and then selects the first suggestion.

Mainly used to test the typescript snippets.
"""

from sys import exit as system_exit
import subprocess

from config import COMMAND_TO_RUN

import pyautogui


def case_time_works():
    """Tests the tests are working, BRILLIANT"""
    # Type the text
    pyautogui.typewrite("itime", interval=0.1)
    # send ctrl + space to select the first suggestion
    pyautogui.hotkey("ctrl", "space")
    input("Is it working? ")
    pyautogui.typewrite(["enter"], interval=0.1)


def main():
    """Main Function"""
    # Open Terminal using the command, don't block
    with subprocess.Popen(COMMAND_TO_RUN, shell=True) as running_command:
        # Wait for the termin Fal to Open
        pyautogui.sleep(3)
        # Cases
        case_time_works()
        # Close the Terminal
        running_command.kill()
    return 0


if __name__ == "__main__":
    system_exit(main())
