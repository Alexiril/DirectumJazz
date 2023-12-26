import QtQuick 2.3
import Sailfish.Silica 1.0
import Directum.Network 1.0

Page {
    id: page

    DirectumData {
        id: directumData
    }

    onVisibleChanged: {
        if (visible)
            console.log("Assignment Id is ", directumData.get_reg(0))
    }
}
