#!/usr/bin/env python
# -*- coding: utf-8 -*-

#inspired by https://github.com/milkbikis/powerline-shell/blob/master/segments/git.py

import re
import subprocess
import sys
import os

def get_git_status():
  has_pending_commits = True
  has_untracked_files = False
  origin_position = ""
  output = subprocess.Popen(['git', 'status', '--ignore-submodules'], env={"LANG": "C", "HOME": os.getenv("HOME")}, stdout=subprocess.PIPE).communicate()[0]
  for line in output.split('\n'):
    origin_status = re.findall(
      r"Your branch is (ahead|behind).*?(\d+) comm", line)
    if origin_status:
      origin_position = " %d" % int(origin_status[0][1])
      if origin_status[0][0] == 'behind':
        origin_position += '$git_behind_symbol'
      if origin_status[0][0] == 'ahead':
        origin_position += '$git_ahead_symbol'

    if line.find('nothing to commit') >= 0:
      has_pending_commits = False
    if line.find('Untracked files') >= 0:
      has_untracked_files = True
  return has_pending_commits, has_untracked_files, origin_position


def git_parse():
  # See http://git-blame.blogspot.com/2013/06/checking-current-branch-programatically.html
  p = subprocess.Popen(['git', 'symbolic-ref', '-q', 'HEAD'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  out, err = p.communicate()

  status = 'on'

  has_pending_commits, has_untracked_files, origin_position = get_git_status()


  if 'Not a git repo' in err:
    return

  if out:
    branch = out[len('refs/heads/'):].rstrip()
  else:
    branch = '(Detached)'

  if has_pending_commits:
    status += '$RED ' + branch + ' $git_dirty_symbol'
  else:
    status += '$GREEN ' + branch + ' $git_clean_symbol'

  if has_untracked_files:
    status += ' $ORANGE$git_untracked_symbol'

  status += origin_position
  status += '$NOCOLOR'

  return status

if __name__ == "__main__":
  sys.stdout.write(git_parse())
