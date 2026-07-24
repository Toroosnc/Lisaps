import asyncio
import json
import time
import uuid
from pathlib import Path

import flet as ft

APP_NAME = "Lisaps"

#System Theme
BG_DARK = "#0B1020"
BG_CARD = "#171C33"
ACCENT_1 = "#7C4DFF"   # ungu
ACCENT_2 = "#42C6FF"   # biru muda
TEXT_MUTED = "#8A8FA3"
DANGER = "#FF5A7A"

DATA_FILE = Path.home() / ".lisaps" / "tasks.json"


# ---------- penyimpanan data (persisten di file lokal) ----------
def load_tasks() -> list[dict]:
    try:
        if DATA_FILE.exists():
            return json.loads(DATA_FILE.read_text(encoding="utf-8"))
    except Exception:
        pass
    return []


def save_tasks(tasks: list[dict]) -> None:
    DATA_FILE.parent.mkdir(parents=True, exist_ok=True)
    DATA_FILE.write_text(json.dumps(tasks, ensure_ascii=False, indent=2), encoding="utf-8")


async def main(page: ft.Page):
    page.title = APP_NAME
    page.bgcolor = BG_DARK
    page.padding = 0
    page.window.width = 420
    page.window.height = 780
    page.window.min_width = 360
    page.window.min_height = 560
    page.theme_mode = ft.ThemeMode.DARK
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER
    page.fonts = {}

    tasks: list[dict] = load_tasks()
    current_filter = {"value": "all"}  # all | active | done

    # ---------- state UI yang perlu direferensikan ulang ----------
    task_list_view = ft.Column(spacing=10, animate_size=250)
    progress_bar = ft.ProgressBar(
        value=0, width=None, height=8, color=ACCENT_2, bgcolor="#232A45",
        border_radius=10,
    )
    progress_label = ft.Text("0 / 0 selesai", size=12, color=TEXT_MUTED)
    new_task_field = ft.TextField(
        hint_text="Tulis tugas baru...",
        border_radius=14,
        border_color="transparent",
        filled=True,
        fill_color=BG_CARD,
        color="white",
        content_padding=ft.padding.symmetric(horizontal=16, vertical=14),
        text_size=14,
        expand=True,
        on_submit=lambda e: page.run_task(add_task),
    )

    filter_chips = {}

    def chip(label: str, key: str):
        selected = current_filter["value"] == key

        def on_click(e):
            current_filter["value"] = key
            for k, c in filter_chips.items():
                c.bgcolor = ACCENT_1 if k == key else BG_CARD
                c.content.color = "white" if k == key else TEXT_MUTED
            refresh_list()
            page.update()

        c = ft.Container(
            content=ft.Text(label, size=13, weight=ft.FontWeight.W_600,
                             color="white" if selected else TEXT_MUTED),
            padding=ft.padding.symmetric(horizontal=16, vertical=8),
            border_radius=20,
            bgcolor=ACCENT_1 if selected else BG_CARD,
            on_click=on_click,
            animate=ft.Animation(200, ft.AnimationCurve.EASE_OUT),
        )
        filter_chips[key] = c
        return c

    empty_state = ft.Column(
        [
            ft.Icon(ft.Icons.CHECKLIST_ROUNDED, size=64, color="#2A3153"),
            ft.Text("Belum ada tugas", size=15, color=TEXT_MUTED, weight=ft.FontWeight.W_500),
            ft.Text("Tambahkan tugas pertamamu di atas ✨", size=12, color="#565C78"),
        ],
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=6,
    )

    # ---------- helper UI: satu baris tugas ----------
    def build_task_row(task: dict) -> ft.Container:
        def on_toggle(e):
            task["done"] = e.control.value
            save_tasks(tasks)
            update_progress()
            # animasi kecil: highlight lalu balik normal
            row.bgcolor = "#20263F" if not task["done"] else BG_CARD
            title.color = TEXT_MUTED if task["done"] else "white"
            title.style = ft.TextStyle(
                decoration=ft.TextDecoration.LINE_THROUGH if task["done"] else None
            )
            page.update()
            refresh_list()

        async def on_delete(e):
            row.opacity = 0
            row.offset = ft.Offset(0.25, 0)
            page.update()
            await asyncio.sleep(0.22)
            tasks.remove(task)
            save_tasks(tasks)
            refresh_list()
            update_progress()

        title = ft.Text(
            task["text"],
            size=14,
            color=TEXT_MUTED if task["done"] else "white",
            style=ft.TextStyle(
                decoration=ft.TextDecoration.LINE_THROUGH if task["done"] else None
            ),
            expand=True,
        )

        row = ft.Container(
            content=ft.Row(
                [
                    ft.Checkbox(
                        value=task["done"],
                        active_color=ACCENT_1,
                        check_color="white",
                        on_change=on_toggle,
                    ),
                    title,
                    ft.IconButton(
                        icon=ft.Icons.DELETE_OUTLINE_ROUNDED,
                        icon_color=DANGER,
                        icon_size=19,
                        on_click=on_delete,
                    ),
                ],
                alignment=ft.MainAxisAlignment.START,
            ),
            bgcolor=BG_CARD,
            border_radius=14,
            padding=ft.padding.symmetric(horizontal=10, vertical=2),
            opacity=0,
            offset=ft.Offset(0, 0.15),
            animate_opacity=ft.Animation(280, ft.AnimationCurve.EASE_OUT),
            animate_offset=ft.Animation(280, ft.AnimationCurve.EASE_OUT),
        )
        return row

    def update_progress():
        total = len(tasks)
        done = len([t for t in tasks if t["done"]])
        progress_bar.value = (done / total) if total else 0
        progress_label.value = f"{done} / {total} selesai"

    def refresh_list():
        task_list_view.controls.clear()
        filtered = tasks
        if current_filter["value"] == "active":
            filtered = [t for t in tasks if not t["done"]]
        elif current_filter["value"] == "done":
            filtered = [t for t in tasks if t["done"]]

        if not filtered:
            task_list_view.controls.append(empty_state)
        else:
            for t in sorted(filtered, key=lambda x: x["created"], reverse=True):
                task_list_view.controls.append(build_task_row(t))
        update_progress()
        page.update()
        # trigger animasi masuk setelah frame pertama render
        page.run_task(animate_in)

    async def animate_in():
        await asyncio.sleep(0.03)
        for c in task_list_view.controls:
            if isinstance(c, ft.Container):
                c.opacity = 1
                c.offset = ft.Offset(0, 0)
        page.update()

    async def add_task():
        text = (new_task_field.value or "").strip()
        if not text:
            return
        tasks.append({
            "id": str(uuid.uuid4()),
            "text": text,
            "done": False,
            "created": time.time(),
        })
        save_tasks(tasks)
        new_task_field.value = ""
        new_task_field.focus()
        refresh_list()

    add_button = ft.Container(
        content=ft.Icon(ft.Icons.ADD_ROUNDED, color="white", size=24),
        width=48,
        height=48,
        border_radius=14,
        gradient=ft.LinearGradient(colors=[ACCENT_1, ACCENT_2]),
        alignment=ft.alignment.center,
        on_click=lambda e: page.run_task(add_task),
        animate_scale=ft.Animation(120, ft.AnimationCurve.EASE_OUT),
        on_hover=lambda e: (
            setattr(e.control, "scale", 1.06 if e.data == "true" else 1.0),
            page.update(),
        ),
    )

    header = ft.Container(
        content=ft.Column(
            [
                ft.Row(
                    [
                        ft.Row(
                            [
                                ft.Container(
                                    content=ft.Icon(ft.Icons.BOLT_ROUNDED, color="white", size=20),
                                    width=38, height=38, border_radius=12,
                                    gradient=ft.LinearGradient(colors=[ACCENT_1, ACCENT_2]),
                                    alignment=ft.alignment.center,
                                ),
                                ft.Text(APP_NAME, size=22, weight=ft.FontWeight.W_800, color="white"),
                            ],
                            spacing=10,
                        ),
                    ],
                    alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                ),
                ft.Container(height=14),
                progress_bar,
                ft.Container(height=4),
                progress_label,
            ]
        ),
        padding=ft.padding.only(left=22, right=22, top=26, bottom=6),
    )

    filters_row = ft.Container(
        content=ft.Row(
            [chip("Semua", "all"), chip("Aktif", "active"), chip("Selesai", "done")],
            spacing=8,
        ),
        padding=ft.padding.only(left=22, right=22, top=14, bottom=6),
    )

    input_row = ft.Container(
        content=ft.Row([new_task_field, add_button], spacing=10),
        padding=ft.padding.symmetric(horizontal=22, vertical=12),
    )

    list_container = ft.Container(
        content=task_list_view,
        padding=ft.padding.only(left=22, right=22, top=6, bottom=24),
        expand=True,
    )

    page.add(
        ft.Column(
            [
                header,
                input_row,
                filters_row,
                ft.Container(
                    content=ft.Column([list_container], scroll=ft.ScrollMode.AUTO, expand=True),
                    expand=True,
                ),
            ],
            spacing=0,
            expand=True,
        )
    )

    refresh_list()


ft.run(main)