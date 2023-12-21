import QtQuick 2.0
import Sailfish.Silica 1.0
import Directum.Network 1.0

Page {
    id: page

    function update() {
        busyLabel.running = true
        mailListView.model.clear()
        directumData.make_get_request("IAssignments?$expand=Author,MainTask&$orderby=Status desc, Importance")
    }

    allowedOrientations: Orientation.Portrait

    DirectumData {
        id: directumData

        property var components_types: ({})

        onGetRequestIsFinished: {
            busyLabel.running = false
            if (request_answer_code === 200) {
                var json = JSON.parse(request_answer)
                json.value.forEach(function(result) {
                    var component = Qt.createComponent(Qt.resolvedUrl("AssignmentsViewerItem.qml"))
                    component.Id = result.Id
                    component.MainTaskId = result.MainTask.Id
                    component.TopicsName = result.Subject
                    if (result.Deadline === null)
                        component.Deadline = qsTr("Never")
                    else
                        component.Deadline = result.Deadline
                    component.Author = result.Author.Name
                    component.Status = result.Status.replace(/([A-Z])/g, ' $1').trim()
                    component.InProcess = result.Status === "InProcess"
                    component.Importance = result.Importance
                    component.Important = result.Importance === "High" && component.InProcess
                    mailListModel.append(component)
                });
            }
            else {
                pageStack.pull()
            }
        }
    }

    BusyLabel {
        id: busyLabel
        running: false
    }

    SilicaListView {
        id: mailListView
        header: PageHeader {title: qsTr("All tasks")}
        footer: ButtonLayout {
            Button {
                id: updateButton
                text: qsTr("Update")
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    margins: Theme.horizontalPageMargin
                }
                onClicked: {
                    page.update()
                }
            }
        }
        spacing: Theme.paddingLarge
        width: parent.width;
        height: parent.height
        anchors{top: parent.top}
        model: ListModel {
            id: mailListModel
        }

        delegate: ListItem {
            onClicked: {
                openMenu()
            }

            width: parent.width
            contentHeight: Theme.itemSizeLarge + Theme.itemSizeSmall
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }

            menu: Component {
                ContextMenu {
                    MenuItem {
                        text: qsTr("Open")
                        onClicked: {
                            console.log("Opening assignment with id=" + Id + " and main task id=" + MainTaskId)
                        }
                    }

                    MenuItem {
                        visible: InProcess
                        text: qsTr("Abort")
                        onClicked: {
                            if (!InProcess)
                                return
                            console.log("Aborting task (and all assigments) with id=" + MainTaskId)
                        }
                    }

                    MenuItem {
                        visible: InProcess
                        text: qsTr("Complete")
                        onClicked: {
                            if (!InProcess)
                                return
                            busyLabel.running = true
                            var request = new XMLHttpRequest()
                            var address = "https://cpp-student.starkovgrp.ru/Integration/odata/Docflow/CompleteAssignment"
                            request.open('POST', address, true)
                            request.onreadystatechange = function() {
                                if (request.readyState === XMLHttpRequest.DONE) {
                                    if (request.status && (request.status === 200 || request.status === 204)) {
                                        console.log("done")
                                        page.update()
                                    } else {
                                        console.log("HTTP:", request.status, request.statusText, request.responseText)
                                    }
                                    busyLabel.running = false;
                                }
                            }
                            request.setRequestHeader('Authorization', "Bearer " + directumData.get_user_token())
                            request.setRequestHeader('Content-Type', 'application/json')
                            const params = JSON.stringify({ assignmentId: Id, result: "Complete" })
                            console.log(params)
                            request.setRequestHeader("Content-length", params.length);
                            request.send(params)
                        }
                    }
                }
            }

            Label {
                id: topicsName
                text: TopicsName
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.highlightColor
                anchors {
                    margins: {
                        left: Theme.paddingSmall
                        right: Theme.paddingSmall
                        top: Theme.paddingLarge
                        bottom: Theme.paddingLarge
                    }
                }
                font.strikeout: !InProcess
                height: Theme.paddingLarge + Theme.fontSizeMedium
            }

            Label {
                id: importance
                text: qsTr("Importance: ") + Importance
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    top: topicsName.bottom
                }
                x: Theme.paddingLarge
                color: Important ? Theme.highlightColor : Theme.primaryColor
            }

            Label {
                id: deadline
                text: qsTr("Deadline: ") + Deadline
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    top: importance.bottom
                }
                x: Theme.paddingLarge
            }

            Label {
                id: status
                text: qsTr("Status: ") + qsTr(Status)
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    top: deadline.bottom
                }
                x: Theme.paddingLarge
            }

            Label {
                id: author
                text: qsTr("Author: ") + Author
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    top: status.bottom
                }
                x: Theme.paddingLarge
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            page.update()
        }
    }

}
