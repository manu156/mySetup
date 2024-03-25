#!/bin/bash

# CHANGE username in delete_logs.service for your username
sudo cp ./service/delete_logs.service /etc/systemd/system/
sudo cp ./timer/delete_logs.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now delete_logs.timer