import QtQuick 2.0
import Sailfish.Silica 1.0
import Directum.Network 1.0

Page {
    objectName: "fieldsViewerPage"
    allowedOrientations: Orientation.Portrait

    DirectumData {
        id: directumData

        property var components_types: ({})

        onGetRequestIsFinished: {
            busyLabel.running = false
            if (request_answer_code === 200) {
                var json = JSON.parse(request_answer)
                json.value.forEach(function(item) {
                    var request = new XMLHttpRequest()
                    var address = "https://cpp-student.starkovgrp.ru/Integration/odata/I" + item.type + "s(" + item.id + ")"
                    components_types[item.id] = item.type
                    request.open('GET', address)
                    request.onreadystatechange = function() {
                        if (request.readyState === XMLHttpRequest.DONE) {
                            if (request.status && request.status === 200) {
                                console.log(request.responseText)
                                var result = JSON.parse(request.responseText)
                                var component = Qt.createComponent(Qt.resolvedUrl("MailViewerItem.qml"))
                                component.Id = result.Id
                                component.Type = components_types[result.Id]
                                component.TopicsName = result.Subject
                                component.SupportData = result.Deadline
                                mailListModel.append(component)
                            } else {
                                console.log("HTTP:", request.status, request.statusText)
                            }
                        }
                    }
                    request.setRequestHeader('Authorization', "Bearer " + directumData.get_user_token())
                    request.send()
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
        header: PageHeader {title: "Recent"}
        width: parent.width;
        height: parent.height
        model: ListModel {
            id: mailListModel
        }

        delegate: ListItem {
            onClicked: {
                console.log("Clicked " + Id + " " + Type);
            }

            width: parent.width
            contentHeight: Theme.itemSizeLarge + Theme.itemSizeSmall
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.paddingLarge
            }

            Label {
                id: topicsName
                text: TopicsName
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.highlightColor
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingSmall
                }
                height: Theme.paddingSmall + Theme.fontSizeMedium
            }

            Label {
                id: fromEmail
                text: qsTr("Data: ") + SupportData
                font.pixelSize: Theme.fontSizeSmall
                anchors {
                    top: topicsName.bottom
                }
                x: Theme.paddingLarge
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            busyLabel.running = true
            directumData.make_get_request("DirectumAurora/GetShortRecentTasks")
        }
    }

}
