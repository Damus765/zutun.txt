# ZuTun.txt

Manage tasklists in todo.txt format on SailfishOS.

Todo.txt uses simple text files for managing tasklists: http://todotxt.com/

## Source

https://github.com/fuchsmich/zutun.txt

## Translation 

https://www.transifex.com/none-496/zutuntxt/dashboard/

## Installation

Download the rpm from [openrepos](https://openrepos.net/content/fooxl/zutuntxt) or [releases](https://github.com/fuchsmich/zutun.txt/releases/latest).


## Features

  - sort/group Tasks:
    - alphabetically
    - by creation date
    - by contexts
    - by projects
  - filter tasks
    - hide completed tasks
    - by project or context
    - combine filters
  - edit tasks
    - datepicker for due date
    - auto-add creation date when adding new task
    - show tasks with due date in notifications
    - add task from top menu (app must be running)
  - configureable notifications for tasks with due date
  - add task via global top menu
  
  
## Changes

### 2.3.0
  - setting to hide completion date
  - check task when clicking on row
  - menu item to edit task
  - pushup menu to uncheck all tasks
  - option to disable sorting

### 2.2.2
  - update languages: fr, zh

### 2.2.1
  - update languages: sv, zh

### 2.2.0
  - start zutun.txt with shortcut (pulldown menu)
  - improved notifications (format, more stable handling)
  - settings for notifications
  - removed bug in onFiltersChanged

### 2.1.4
  - reload file when activating the app

### 2.1.3
  - update languages: es, zh

### 2.1.2
  - update languages: fr
  - trim (new) tasks after editing

### 2.1
  - update languages: sv
  - recent files in settings
  - fixed some bugs when changing from one file to another
  - better hint when all tasks filtered
  - clear multiple spaces when adding task

### 2.0
  - advanced filters (or, not)
  - filter with search field
  - read file only if there are changes
  - option to autoadd creationDate on task creation
  - locale formatted dates for due and completion dates
  - filters on one page
  - list doesnt jump anymore after editing a task
  - gridmenu in taskedit
  - improved file handling and error feedback
  - create file from app
  - some work on cover
  - icon 172x172

### 1.7.2
  - updated langs: es

### 1.7.1
  - updated langs: nl, nl_BE, de, sv

### 1.7
  - cover: background image full size
  - taskedit: enter key bound to accept
  - notification: open app when clicking on notification
  - taskedit: new calendar widget for due:
  - taskedit: insert context/project at cursorposition

### 1.6
  - quickaction/shortcut added (app must be running)

### 1.5.1
  - update (some) translations
  - depend on linguist for obs merproject

### 1.5
  - due: support incl. notifications
  - nl, ru and es translation

### 1.4.1-1
  - added Readme
  - swedish and german translation

### 1.4-1
  - native FilePicker
  - cursorposition
  - grouping by projects and contexts

### 1.3-1
  - FIX doubeled tasks after edit
  - better focus handling and cursor positioning in edit

### 1.2-1
  - colored projects and contexts in tasklist

### 1.1-1
  - option for project filter left of tasklist
  - pulldownmenu: first position for add task

### 1.0-2
  - automatic reload of file, when app or cover catches focus
  - spacing in filters

### 0.99-2
  - correct todo.txt syntax (swapped priority and completion date fields
  - filepicker
  - sorting
  - a lot of code rewrite

### 0.5-1
  - reduced space between items

### 0.4-1
  - Insert priority bug

### 0.3-1
  - filters: show number of visible items/total items
  - bug in coveraction overwriting first item
  - setting/resetting font size in tasklist

### 0.2-1
  - slight changes to icon
  - settings text field width corrected
  - cover: icon added
  - save filter settings
  - preview on cover
  - appname in desktop file

### 0.1-1
  - initial release
  - filter projects, contexts, done items
  - edit items
  - delete items
  - +/- priority
  - paste priority, todays date, project or context
  - set file path for todo.txt file
