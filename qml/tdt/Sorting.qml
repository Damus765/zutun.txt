import QtQuick 2.0
import "todotxt.js" as JS


QtObject {
    signal sortingChanged()

    property bool asc: true
    onAscChanged: sortingChanged()

    //sort according to: 0..fullTxt, 1..creation date, 2..due date, 3..subject
    property int order: 0
    onOrderChanged: sortingChanged()

    //group by: 0..none, 1..projects, 2..contexts
    property int groupBy: 0
    onGroupByChanged: sortingChanged()

    readonly property var sectionProperty: {
        return ["none", "projects", "contexts"][groupBy]
    }

    property string sortText: qsTr("Sorted by %1").arg(functionList[order].name + ", " + (asc ? qsTr("asc") : qsTr("desc")))
    property string groupText: (groupBy > 0 ? qsTr("Grouped by %1, ").arg(groupFunctionList[groupBy].name) : "")

    //returns a function, which compares two items
    property var lessThanFunc: groupFunctionList[groupBy].lessThanFunc
    property var shouldSort: function () { return functionList[order].shouldSort }

    //list of functions for sorting; *left* and *right* are the items to compare
    property var functionList: [
        {
            //: SortPage, sorting by: None
            name: qsTr("None"),
            shouldSort: false,
            lessThanFunc: null
        },
        {
            //: SortPage, sorting by: Natural
            name: qsTr("Natural"),
            shouldSort: true,
            lessThanFunc: function(left, right) {
                //TODO ä wird nach x gereiht! locale?
                return left.fullTxt === right.fullTxt
                    ? false
                    : (left.fullTxt < right.fullTxt) ^ !asc
            }
        },
        {
            //: SortPage, sorting by: Creation date
            name: qsTr("Creation Date"),
            shouldSort: true,
            lessThanFunc: function(left, right) {
                return left.creationDate === right.creationDate
                    ? functionList[1].lessThanFunc(left, right)
                    : (left.creationDate < right.creationDate) ^ !asc
            }
        },
        {
            //: SortPage, sorting by: Due date
            name: qsTr("Due date"),
            shouldSort: true,
            lessThanFunc: function(left, right) {
                return left.due === right.due
                    ? functionList[1].lessThanFunc(left, right)
                    : (left.due < right.due) ^ !asc
            }
        },
        {
            //: SortPage, sorting by: Subject
            name: qsTr("Subject"),
            shouldSort: true,
            lessThanFunc: function(left, right) {
                return left.subject === right.subject
                    ? functionList[1].lessThanFunc(left, right)
                    : (left.subject < right.subject) ^ !asc
            }
        }
    ]

    //0..Name, 1..lessThanFunc, 2..return list of groups
    property var groupFunctionList: [
        {
            //: SortPage, group by: None
            name: qsTr("None"),
            lessThanFunc: function(left, right) {
                return functionList[order].lessThanFunc(left, right)
            },
        },
        {
            //: SortPage, group by: projects
            name: qsTr("Projects"),
            lessThanFunc: function(left, right) {
                return left.projects === right.projects
                    ? functionList[order].lessThanFunc(left, right)
                    : (left.projects < right.projects) ^ !asc
            }
        },
        {
            //: SortPage, group by: contexts
            name: qsTr("Contexts"),
            lessThanFunc: function(left, right) {
                return left.contexts === right.contexts
                    ? functionList[order].lessThanFunc(left, right)
                    : (left.contexts < right.contexts) ^ !asc
            }
        }
    ]
}
