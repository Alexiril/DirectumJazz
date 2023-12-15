import QtQuick 2.0
import Sailfish.Silica 1.0
import Directum.Network 1.0

Page {
    objectName: "fieldsViewerPage"
    allowedOrientations: Orientation.Portrait

    DirectumData {
        id: directumData

        onGetRequestIsFinished: {
            console.log(request_answer)
            busyLabel.running = false
            return;
            if (request_answer_code === 200) {
                var json = JSON.parse(request_answer);
                json.value.forEach(function(item) {
                    var component = Qt.createComponent(Qt.resolvedUrl("MailViewerItem.qml"));
                    component.Id = item.id;
                    component.Type = item.type;
                    directumData.make_get_request("I" + item.type + "s(" + item.Id + ")");
                    mailListModel.append(component);
                });
            }
            else {
                pageStack.pull();
            }
        }
    }

    BusyLabel {
        id: busyLabel
        running: false
    }

    SilicaListView {
        header: PageHeader {title: "table"}
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
