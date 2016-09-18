import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import org.nemomobile.configuration 1.0

import FileIO 1.0

//TODO archive to done.txt
//TODO fehler über notifiactions ausgeben
//TODO eigene Filter Component



ApplicationWindow
{
    id: app
    initialPage: Component { TaskList{} }

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All


    ConfigurationGroup {
        //TODO filter p+c+d speichern
        id: settings
        path: "/apps/harbour-zutun/settings"
        property string todoTxtLocation: StandardPaths.documents + '/todo.txt'
        property string doneTxtLocation: StandardPaths.documents + '/done.txt'
        property bool autoSave: true
        //        Component.onCompleted: {
        //            console.log("settings", path, todoTxtLocation, doneTxtLocation, autoSave)
        //        }
    }

    PCListModel {
        id: projectModel
        assArray: tdt.projects
    }

    PCListModel {
        id: contextModel
        assArray: tdt.contexts
    }

    QtObject {
        id: filters
//        property string filterString: filterText()
        property bool done: false

        property var pfilter: projectModel.filter
        property var cfilter: contextModel.filter

        function string() {
            var pf = projectModel.filter.toString(), cf = contextModel.filter.toString();

            var txt = pf + (pf === "" || cf === "" ? "" : "," ) + cf;
            if (txt === "" && done) return "Completed Tasks";
            return ( txt === "" ? "All Tasks" : txt );
        }

        /* returns the visibility in tasklist due to filters */
        function itemVisible(index) {
            index = index.toString();
            var dvis = !(done && tdt.taskList[index][tdt.done] !== undefined);
            var cvis = (cfilter.length === 0), pvis = (pfilter.length === 0);
            for (var p in pfilter) {
                pvis = pvis || (tdt.projects[pfilter[p]].indexOf(index) !== -1)
//                console.log(index, pvis, pfilter[p], projects[pfilter[p]], typeof index, projects[pfilter[p]].indexOf(index));
            }
            for (var c in cfilter) {
//                console.log(index, cvis, cfilter[c], contexts[cfilter[c]], typeof index, contexts[cfilter[c]].indexOf(index));
                cvis = cvis || (tdt.contexts[cfilter[c]].indexOf(index) !== -1)
            }

//            console.log(pvis, cvis, dvis)
            return pvis && cvis && dvis;
        }
    }



    Item {
        id: tdt
        property var initialPage

        readonly property int fullTxt: 0
        readonly property int done: 1
        readonly property int doneDate: 2
        readonly property int priority: 3
        readonly property int creationDate: 4
        readonly property int subject: 5

        readonly property string alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        property url source: StandardPaths.documents + '/todo.txt'
        property var taskList: [] // 2d array with fullTxt, done, doneDate, priority, creationDate, subject
        property ListModel tasksModel: tasksModel
        property int count: 0
        property var projects: [] //+ assoziertes Array
        property var contexts: [] //@ assoziertes Array


        property string lowestPrio: "(A) "

        onLowestPrioChanged: console.log(lowestPrio)

        ListModel {
            id: tasksModel

            property var assArray: tdt.taskList
            onAssArrayChanged: populate(assArray);

            function populate(array) {
//                clear();
                for (var a = 0; a < array.length; a++) {
//                    append( { "id": a,
//                               "fullTxt": array[a][tdt.fullTxt], "done": tdt.getDone(a),
//                               "doneDate": array[a][tdt.doneDate], "priority": tdt.getPriority(a),
//                               "creationDate": array[a][tdt.creationDate], "subject": array[a][tdt.subject]
//                           });
                    if (a < count) set(a, { "id": a, "fullTxt": array[a][tdt.fullTxt], "done": tdt.getDone(a),
                               "displayText": '<font color="' + tdt.getColor(a) + '">' + tdt.getPriority(a)+ '</font>'
                                + tdt.taskList[a][tdt.subject]
                           });
                    else append( { "id": a, "fullTxt": array[a][tdt.fullTxt], "done": tdt.getDone(a),
                                    "displayText": '<font color="' + tdt.getColor(a) + '">' + tdt.getPriority(a)+ '</font>'
                                     + tdt.taskList[a][tdt.subject]
                                });
                }
                console.log(a, count);

                if (a < count) remove(a, (count - a) )

//                if (count > array.length) remove((count - array.length), )

            }

//            function sort(index) {
//                var a = [];
//                for (var i =0; i < count; i++){
//                    a.push([get(i).fullTxt, i]);
//                }
//                console.log(a);
//                a.sort(function (a,b) {
//                    if (b[0] > a[0]) return -1;
//                    return 1;
//                });
//                console.log(a);
//            }



//            function syncToFile() {

//            }
        }



        /* get done state */
        function getDone(index) {
            if (index >= 0 && index < taskList.length) {
                return (typeof taskList[index][done] !== 'undefined' ? (taskList[index][done][0] === 'x') : false);
            } else throw "done: Index out of bounds."
        }

        function today() {
            return Qt.formatDate(new Date(),"yyyy-MM-dd");
        }



        /* set done state and done date */
        function setDone(index, value) {
            if (index >= 0 && index < taskList.length) {
                if (value && !getDone(index))
                    taskList[index][fullTxt] =
                            "x " + today() + " " + taskList[index][fullTxt];
                if (!value && getDone(index))
                    taskList[index][fullTxt] =
                            taskList[index][fullTxt].match(/(x\s)?(\d{4}-\d{2}-\d{2}\s)?(.*)/)[3]; //Datum muss auch weg!!
                listToFile();
            } else throw "done: Index out of bounds."
        }

        /* delete todo item */
        function removeItem(index) {
            if (index >= 0 && index < taskList.length) {
                var l = [];
                for (var t in taskList) {
                    if (t != index) {
                        l.push(taskList[t]);
                    }

                }
                taskList = l;
                listToFile();
            } else throw "done: Index out of bounds."
        }

        /* get Priority */
        function getPriority(index) {
            if (index >= 0 && index < taskList.length) {
                return (typeof tdt.taskList[index][tdt.priority] !== 'undefined' ? tdt.taskList[index][tdt.priority] : "");
            } else throw "done: Index out of bounds."
        }

        /* return increased/decreased Priority-string */
        function incPrioString(p) {
            if (p[1] === alphabet[0]) return p;
            else return "(" + String.fromCharCode(p.charCodeAt(1) - 1) + ") ";
        }

        function decPrioString(p) {
            if (p[1] === alphabet[alphabet.length-1]) return p;
            else return "(" + String.fromCharCode(p.charCodeAt(1) + 1) + ") ";
        }

        function raisePriority(index) {
            if (taskList[index][priority] === undefined)
                taskList[index][fullTxt] = (decPrioString(lowestPrio) + taskList[index][fullTxt]).trim();

            else if (taskList[index][priority][1] > alphabet[0])
                taskList[index][fullTxt] = incPrioString(taskList[index][priority])
                        + taskList[index][fullTxt].substr(4);

            else return;

            listToFile();
        }

        function lowerPriority(index) {

            if (taskList[index][priority] !== undefined) {
                if (taskList[index][priority][1] < alphabet[alphabet.length-1])
                    taskList[index][fullTxt] = decPrioString(taskList[index][priority])
                            + taskList[index][fullTxt].substr(4);

                else if (taskList[index][priority][1] === alphabet[alphabet.length-1])
                    taskList[index][fullTxt] = taskList[index][fullTxt].substr(4).trim();
            }

            else return;

            listToFile();
        }

        function setPriority(index, prio) {

        }


        /* get color due to Priority*/
        ColorPicker {
            id: cp
        }

        function getColor(index) {
            //            console.log(index, getPriority(index));
            if (index >= 0 && index < taskList.length) {
                //                console.log(index, getPriority(index), cIndex);
                if (getPriority(index) === "") {
                    if (getDone(index)) return Theme.secondaryColor;
                    else return Theme.primaryColor;
                }
                //                var cIndex = alphabet.search(getPriority(index)[1]);
                return cp.colors[alphabet.search(getPriority(index)[1]) % 15];
            } else throw "done: Index out of bounds."
        }


        /* set fulltext; index = -1 add Item */
        function setFullText(index, txt) {
            /*replace CR and LF; tasks always comprise a single line*/
            txt.replace(/\r/g," ");
            txt.replace(/\n/g," ");

            txt = txt.trim();

            //TODO leerer Text: bestehendes todo löschen, wenn text leer
            if (txt !== "") {
                if (index === -1) taskList.push([txt]);
                else taskList[index][fullTxt] = txt;
                listToFile();
            }
        }


        /* sort list and write it to the txtFile*/
        function listToFile() {
            taskList.sort();
            var txt = "";
            for (var t in taskList) {
                txt += taskList[t][fullTxt] + "\n";
            }
            todoTxtFile.content = txt;
        }


        /* parse plain Text*/
        function parseTodoTxt(todoTxt) {
            var tlist = [];
            var plist = [];
            var clist = [];
            var tasks = todoTxt.split("\n");
            tasks.sort();


            //clean lines, remove empty lines
            var txt = "";
            for (var t in tasks) {
                txt = tasks[t].trim();
                if (txt.length !== 0) tlist.push(txt);
            }
            tasks = tlist;

            count = tasks.length;

            //parse lines
            tlist = [];
            for (t in tasks) {
                //                console.log(t, tasks[t]);
                txt = tasks[t];

                //alles auf einmal fullTxt, done, doneDate, priority, creationDate, subject
                var matches = txt.match(/^(x\s)?(\d{4}-\d{2}-\d{2}\s)?(\([A-Z]\)\s)?(\d{4}-\d{2}-\d{2}\s)?(.*)/);
                tlist.push(matches);


                /* find lowest prio*/
                lowestPrio = (matches[priority] > lowestPrio ? matches[priority] : lowestPrio);


                /* collect projects (+) and contexts (@)*/
                var m;
                var pmatches = matches[subject].match(/\s\+\w+(\s|$)/g);
                for (var p in pmatches) {
                    m = pmatches[p].toUpperCase().trim();
                    if (typeof plist[m] === 'undefined') plist[m] = [];
                    plist[m].push(t);
//                    console.log(m, plist[m]);
                }

                var cmatches = matches[subject].match(/\s@\w+(\s|$)/g);
                for (var c in cmatches) {
                    m = cmatches[c].toUpperCase().trim();
                    if (typeof clist[m] === 'undefined') clist[m] = [];
                    clist[m].push(t);
//                    console.log(m, clist[m]);
                }



            }

            projects = plist;
            contexts = clist;
            taskList = tlist;
        }


        FileIO {
            id: todoTxtFile
            path: settings.todoTxtLocation
            onContentChanged: tdt.parseTodoTxt(content);
        }
    }
}



