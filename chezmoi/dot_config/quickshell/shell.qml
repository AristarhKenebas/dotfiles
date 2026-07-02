import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

ShellRoot {
    id: root

    property color colBase: "#0a0a0a"
    property color colPrimary: "#e8e8e8"
    property color colAccent: "#ff6eb4"
    property color colMuted: "#555555"
    property color colSubtle: "#1a1a1a"
    property color colSecondary: "#888888"
    property string fontMono: "Monaspace Neon"

    PwObjectTracker { objects: [Pipewire.defaultAudioSink] }
    property var sink: Pipewire.defaultAudioSink
    property int volumePct: sink?.audio ? Math.round(sink.audio.volume * 100) : 0
    property bool muted: sink?.audio ? sink.audio.muted : false

    property int brightnessPct: 0
    Process {
        id: brightnessProbe
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                const fields = this.text.trim().split(",")
                if (fields.length >= 4) root.brightnessPct = parseInt(fields[3].replace("%", ""), 10) || 0
            }
        }
    }
    Timer { interval: 2000; running: true; repeat: true; onTriggered: brightnessProbe.running = true }
    Component.onCompleted: brightnessProbe.running = true

    property bool btPowered: false
    Process {
        id: btProbe
        command: ["bluetoothctl", "show"]
        stdout: StdioCollector { onStreamFinished: root.btPowered = this.text.includes("Powered: yes") }
    }
    Timer { interval: 5000; running: true; repeat: true; onTriggered: btProbe.running = true }

    property string wifiSsid: ""
    property bool wifiConnected: false
    Process {
        id: netProbe
        command: ["nmcli", "-t", "-f", "active,ssid", "dev", "wifi"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = this.text.split("\n").find(l => l.startsWith("yes:"))
                root.wifiConnected = !!line
                root.wifiSsid = line ? line.slice(4) : ""
            }
        }
    }
    Timer { interval: 5000; running: true; repeat: true; onTriggered: netProbe.running = true }
    Component.onCompleted: netProbe.running = true

    property var battery: UPower.displayDevice

    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData
            anchors { top: true; left: true; right: true }
            implicitHeight: 34
            color: root.colBase

            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: root.colSubtle }

            Text {
                id: clockText
                anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 16 }
                color: root.colPrimary; font.family: root.fontMono; font.pixelSize: 13; font.bold: true
                text: Qt.formatDateTime(new Date(), "hh:mm:ss AP")
                Timer { interval: 1000; running: true; repeat: true; onTriggered: clockText.text = Qt.formatDateTime(new Date(), "hh:mm:ss AP") }
            }

            Row {
                anchors.centerIn: parent
                spacing: 4
                Repeater {
                    model: 5
                    Text {
                        required property int index
                        property bool active: Hyprland.focusedWorkspace?.id === (index + 1)
                        text: active ? "■" : "□"
                        color: active ? root.colAccent : root.colMuted
                        font.family: root.fontMono; font.pixelSize: 13
                        MouseArea {
                            anchors.fill: parent; anchors.margins: -4
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Hyprland.dispatch("workspace " + (index + 1))
                        }
                    }
                }
            }

            Row {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 16 }
                spacing: 20

                Text {
                    text: "bri " + root.brightnessPct + "%"
                    color: root.colSecondary; font.family: root.fontMono; font.pixelSize: 13
                    MouseArea {
                        anchors.fill: parent; anchors.margins: -4
                        acceptedButtons: Qt.NoButton
                        onWheel: wheel => {
                            Quickshell.execDetached(["brightnessctl", "set", wheel.angleDelta.y > 0 ? "5%+" : "5%-"])
                            brightnessProbe.running = true
                        }
                    }
                }

                Text {
                    visible: root.battery?.isLaptopBattery ?? false
                    text: "bat " + Math.round((root.battery?.percentage ?? 0) * 100) + "%"
                    color: root.colSecondary; font.family: root.fontMono; font.pixelSize: 13
                }

                Text {
                    text: root.btPowered ? "bt on" : "bt off"
                    color: root.btPowered ? root.colPrimary : root.colMuted
                    font.family: root.fontMono; font.pixelSize: 13
                    MouseArea {
                        anchors.fill: parent; anchors.margins: -4
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.execDetached(["bluetoothctl", "power", root.btPowered ? "off" : "on"])
                            btProbe.running = true
                        }
                    }
                }

                Text {
                    text: root.wifiConnected ? root.wifiSsid : "offline"
                    color: root.wifiConnected ? root.colPrimary : root.colMuted
                    font.family: root.fontMono; font.pixelSize: 13
                }

                Text {
                    text: root.muted ? "mute" : "vol " + root.volumePct + "%"
                    color: root.muted ? root.colAccent : root.colPrimary
                    font.family: root.fontMono; font.pixelSize: 13; font.bold: true
                    MouseArea {
                        anchors.fill: parent; anchors.margins: -4
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (root.sink?.audio) root.sink.audio.muted = !root.sink.audio.muted
                        onWheel: wheel => {
                            if (!root.sink?.audio) return
                            const d = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                            root.sink.audio.volume = Math.max(0, Math.min(1, root.sink.audio.volume + d))
                        }
                    }
                }
            }
        }
    }
}
