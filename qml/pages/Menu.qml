import QtQuick 2.0
import Sailfish.Silica 1.0
import Directum.Network 1.0

Page {
    objectName: "menu"
    allowedOrientations: Orientation.Portrait
    SectionHeader {
        objectName: "mainHeader"
        anchors {horizontalCenter: parent.horizontalCenter}
        text: qsTr("Иди в жопу тебе тут не рады")
    }
}

