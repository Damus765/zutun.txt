import QtQuick 2.0
import Sailfish.Silica 1.0

//TODO filepicker für dateiwahl
//TODO in Dialog umwandeln?

Page {
    id: page
    Column {
        width: parent.width
        PageHeader {
            title: qsTr("Settings")
        }
        SectionHeader {
            text: "Files"
        }

        Label {
            x: Theme.horizontalPageMargin
            text: "Location todo.txt"
        }
        TextField {
            id: todoTxtPath
            x: Theme.horizontalPageMargin
            text: settings.todoTxtLocation
            width: parent.width - 2*Theme.horizontalPageMargin
        }
        Label {
            x: Theme.horizontalPageMargin
            width: parent.width
            text: "Please enter the path manually. Some kind of filepicker or automcompletion will follow in upcoming releases."
            font.pixelSize: Theme.fontSizeTiny
            color: Theme.highlightColor
            wrapMode: Text.WordWrap
        }
        Slider {
            id: fontSizeSlider
            x: Theme.horizontalPageMargin
            width: parent.width
            minimumValue: Theme.fontSizeTiny
            maximumValue: Theme.fontSizeHuge
            value: settings.fontSizeTaskList
            valueText: value
            stepSize: 1
            label: "Fontsize in Tasklist"
        }

        //TODO reset button to Theme.fonSizeMedium

//        Label {
//            x: Theme.horizontalPageMargin
//            text: "Location done.txt"
//        }
//        TextField {
//            id: doneTxtPath
//            x: Theme.horizontalPageMargin
//            text: settings.doneTxtLocation
//        }
//        Button {
//            text: "Select File"
//        }


//        TextSwitch {
//            id: autoSaveSwitch
//            x: Theme.horizontalPageMargin
//            text: qsTr("Autosave")
//            checked: settings.autoSave
//        }
    }
    Component.onDestruction: {
        // write back settings and save
        settings.todoTxtLocation = todoTxtPath.text;
//        settings.doneTxtLocation = doneTxtPath.text;
        settings.fontSizeTaskList = fontSizeSlider.sliderValue;
        settings.sync();
    }
}





