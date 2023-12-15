import QtQuick 2.0
import Sailfish.Silica 1.0
import Directum.Network 1.0


Page {
    objectName: "menuPage"
    allowedOrientations: Orientation.Portrait

    DirectumData {
        id: directumData
    }

    ButtonLayout {

        PageHeader {
            id: menuHeader
            objectName: "menuHeader"
            anchors {horizontalCenter: parent.horizontalCenter}
            title: directumData.get_user_login()
        }

        Button {
            text: "Recent Assignments"
            onClicked: {
                directumData.mail_viewer_state = 1;
                pageStack.push(Qt.resolvedUrl("MailViewer.qml"));
            }
        }

    }
}

