import matplotlib.pyplot as plt


def test_occupancy_matplotlib_final(avg_occupancy):
    """
    גרף דונאט ב-Matplotlib: קומפקטי, נקי, עם כותרת מתוקנת
    """
    if not avg_occupancy:
        avg_occupancy = 0

    vacant = 100 - avg_occupancy
    sizes = [avg_occupancy, vacant]

    # הצבעים שלך: טורקיז וטורקיז-אפרפר בהיר
    colors = ['#00818a', '#e2e8f0']

    # --- הקטנת הגודל ---
    # figsize=(5, 5) יוצר תמונה בגודל בינוני ונוח (לא ענק)
    fig, ax = plt.subplots(figsize=(5, 5))

    # יצירת הדונאט
    wedges, texts = ax.pie(sizes,
                           colors=colors,
                           startangle=90,
                           counterclock=False,
                           # width=0.35 יוצר את הטבעת, edgecolor לבן יוצר את ההפרדה הנקייה
                           wedgeprops={'width': 0.35, 'edgecolor': 'white', 'linewidth': 3})

    # --- המספר במרכז ---
    ax.text(0, 0, f"{avg_occupancy:.1f}%",
            ha='center', va='center',
            fontsize=28, fontweight='bold', color='#001b33')

    # --- הכותרת החדשה (היפוך טקסט לעברית) ---
    title_text = "ממוצע תפוסת טיסות שהתקיימו"[::-1]

    # מיקום הכותרת מעט מעל הגרף
    plt.title(title_text, fontsize=16, weight='bold', color='#64748b', pad=15)

    # הסרת שוליים מיותרים כדי שהגרף לא יחתך
    plt.tight_layout()

    # הצגה בחלון
    plt.show()


# הרצת בדיקה עם נתונים לדוגמה
test_occupancy_matplotlib_final(78.5)


def show_cancellation_bar_test_fixed_scale():
    """
    יוצר ומציג גרף עמודות לשיעור ביטולים עם ציר Y קבוע (0-100%)
    """
    # נתונים לדוגמה
    data = [
        ('2025-01', 0.04),  # 4%
        ('2024-12', 0.12),  # 12%
        ('2024-11', 0.08),  # 8%
        ('2024-10', 0.15),  # 15%
        ('2024-09', 0.06)  # 6%
    ]

    # היפוך סדר הנתונים (מהישן לחדש)
    data = list(reversed(data))
    months = [row[0] for row in data]
    rates = [float(row[1]) * 100 for row in data]

    plt.figure(figsize=(10, 6))

    # יצירת העמודות
    bars = plt.bar(months, rates, color='#00818a', width=0.5, zorder=3)

    # --- התיקון: קיבוע ציר ה-Y מ-0 עד 100 ---
    plt.ylim(0, 100)

    # רשת רקע
    plt.grid(axis='y', linestyle='--', alpha=0.3, zorder=0)

    plt.title("שיעור ביטולים חודשי"[::-1], fontsize=18, weight='bold', color='#001b33', pad=20)

    # עיצוב נקי
    ax = plt.gca()
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_visible(False)
    ax.spines['bottom'].set_color('#cbd5e1')

    plt.tick_params(axis='both', which='both', length=0, labelcolor='#64748b')

    # הוספת התוויות מעל העמודות
    for bar in bars:
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width() / 2., height + 2,  # הרחקתי קצת את הטקסט למעלה (+2)
                 f'{height:.1f}%',
                 ha='center', va='bottom', fontsize=12, weight='bold', color='#001b33')

    plt.tight_layout()

    # הצגה
    plt.show()


# הרצת הבדיקה
show_cancellation_bar_test_fixed_scale()