import QtQuick 2.3
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
                mailListView.visible = true
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
                    if (!component.InProcess)
                        component.Result = result.Result.replace(/([A-Z])/g, ' $1').trim()
                    component.Importance = result.Importance
                    component.Important = result.Importance === "High" && component.InProcess
                    component.IsReview = /.*Review.*/.test(result["@odata.type"])
                    mailListModel.append(component)
                })
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
            contentHeight: Theme.itemSizeLarge + (InProcess ? Theme.itemSizeSmall : Theme.itemSizeLarge)
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
                        text: IsReview ? qsTr("Rework") : qsTr("Abort")
                        onClicked: {
                            if (!InProcess)
                                return
                            console.log("Aborting or sending for rework .id=" + Id)
                        }
                    }

                    MenuItem {
                        id: selfMenuItem
                        visible: InProcess
                        text: IsReview ? qsTr("Accept") : qsTr("Complete")
                        onClicked: {
                            if (!InProcess)
                                return
                            var request = new XMLHttpRequest()
                            var address = "https://" + directumData.get_user_server() + "/Integration/odata/Docflow/CompleteAssignment"
                            request.open('POST', address, true)
                            request.onreadystatechange = function() {
                                if (request.readyState === XMLHttpRequest.DONE) {
                                    if (!request.status || (request.status !== 200 && request.status !== 204)) {
                                        console.log("HTTP:", request.status, request.statusText, request.responseText)
                                    }
                                    busyLabel.running = false
                                    page.update()
                                }
                                console.log(request.readyState)
                            }
                            var timer = Qt.createQmlObject("import QtQuick 2.3; Timer {interval: 10000; repeat: false; running: true;}",page,"TooLongTimer")
                            timer.triggered.connect(function(){
                                page.update()
                            })
                            request.setRequestHeader('Host', directumData.get_user_server())
                            request.setRequestHeader('Authorization', "Bearer " + directumData.get_user_token())
                            request.setRequestHeader('Content-Type', 'application/json')
                            const task_result = IsReview ? "Accepted" : "Complete"
                            const params = JSON.stringify({ assignmentId: Id, result: task_result })
                            console.log(params)
                            request.setRequestHeader("Content-Length", params.length);
                            request.send(params)
                            busyLabel.running = true
                            mailListView.visible = false
                        }
                    }
                }
            }

            Label {
                id: topicsName
                text: TopicsName + (IsReview ? qsTr(" (Review)") : "")
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

            Label {
                id: result
                visible: !InProcess
                text: qsTr("Result: ") + (InProcess ? "" : qsTr(Result))
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    top: author.bottom
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
