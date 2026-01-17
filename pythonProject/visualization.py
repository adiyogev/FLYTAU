import os
import matplotlib.pyplot as plt


def occupancy_donut(avg_occupancy, out_dir, filename="avg_occupancy.png"):
    """
    יוצר גרף דונאט תפוסה ושומר לקובץ בתוך out_dir
    """
    if avg_occupancy is None:
        avg_occupancy = 0

    try:
        avg_occupancy = float(avg_occupancy)
    except (TypeError, ValueError):
        avg_occupancy = 0

    avg_occupancy = max(0, min(100, avg_occupancy))

    vacant = 100 - avg_occupancy
    sizes = [avg_occupancy, vacant]
    colors = ['#00818a', '#e2e8f0']

    fig, ax = plt.subplots(figsize=(6, 6), dpi=160)

    ax.pie(
        sizes,
        colors=colors,
        startangle=90,
        counterclock=False,
        wedgeprops={'width': 0.35, 'edgecolor': 'white', 'linewidth': 3}
    )

    ax.text(
        0, 0, f"{avg_occupancy:.1f}%",
        ha='center', va='center',
        fontsize=32, fontweight='bold', color='#001b33'
    )

    ax.set(aspect="equal")

    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, filename)

    plt.savefig(out_path, bbox_inches="tight", pad_inches=0.02, transparent=True)
    plt.close(fig)

    return out_path


def cancellation_bar(data, out_dir, filename="cancellation_rate.png"):
    """
    data: [(YYYY-MM, rate_as_fraction), ...]
    rate_as_fraction למשל 0.12 = 12%
    """
    if not data:
        data = []

    data = list(reversed(data))
    months = [row[0] for row in data]
    rates = [float(row[1]) * 100 for row in data]  # לאחוזים

    if len(months) == 0:
        months = ["-"]
        rates = [0]

    fig, ax = plt.subplots(figsize=(12, 6), dpi=170)

    bars = ax.bar(months, rates, width=0.55)

    max_rate = max(rates) if rates else 0

    if len(rates) == 1:
        # אם חודש אחד (במיוחד אם 0) — לא נרים ל-100, אלא נעשה סקאלה קטנה
        y_top = 10 if max_rate <= 1 else max(15, max_rate * 2)
    else:
        # אם יש כמה חודשים: סקאלה לפי המקסימום, אבל לא מוגזמת
        y_top = max(10, min(100, max_rate * 1.35 + 2))

    ax.set_ylim(0, y_top)

    # עיצוב נקי
    ax.grid(axis='y', linestyle='--', alpha=0.25)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_visible(False)
    ax.spines['bottom'].set_color('#cbd5e1')
    ax.tick_params(axis='both', which='both', length=0)


    for i, bar in enumerate(bars):
        h = rates[i]
        ax.text(
            bar.get_x() + bar.get_width() / 2,
            bar.get_height() + (y_top * 0.03),
            f"{h:.1f}%",
            ha="center",
            va="bottom",
            fontsize=12,
            fontweight="bold"
        )

    if len(months) > 8:
        plt.xticks(rotation=25, ha='right')

    plt.tight_layout()

    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(out_dir, filename)
    plt.savefig(out_path, bbox_inches="tight", pad_inches=0.02, transparent=True)
    plt.close(fig)

    return out_path
