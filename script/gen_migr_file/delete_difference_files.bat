@echo off
if exist difference.txt (
    del difference.txt
)

if exist difference_ui.txt (
    del difference_ui.txt
)

if exist difference_page.txt (
    del difference_page.txt
)

echo Done
