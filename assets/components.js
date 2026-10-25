/*
 * Reusable lesson components.
 *
 * QUIZ: one answer per question, with feedback straight away.
 *   <div class="quiz" data-answer="2">            (0-based index of the correct option)
 *     <p class="q">Question?</p>
 *     <div class="opts"><button class="opt">…</button> …</div>
 *     <div class="explain">Why…</div>
 *   </div>
 *   Add <p class="score" data-quiz-score></p> anywhere to show a running score.
 *
 * SORTER: click a chip to move it between two buckets, then press Check.
 *   <div class="sorter" data-a="Product" data-b="Variant">
 *     <div class="chips"><button class="chip" data-bucket="a" data-why="…">title</button> …</div>
 *   </div>
 *   The legend, actions and feedback elements are added by the script.
 */
(function () {
  function initQuizzes() {
    const quizzes = [...document.querySelectorAll(".quiz")];
    const scoreEls = document.querySelectorAll("[data-quiz-score]");
    const updateScore = () => {
      const answered = quizzes.filter(q => q.classList.contains("answered"));
      const right = answered.filter(q => q.dataset.result === "right").length;
      scoreEls.forEach(el => el.textContent = `Score: ${right} / ${quizzes.length} (first attempts)`);
    };
    quizzes.forEach(quiz => {
      const answer = Number(quiz.dataset.answer);
      const opts = [...quiz.querySelectorAll("button.opt")];
      const retry = document.createElement("button");
      retry.className = "retry"; retry.type = "button"; retry.textContent = "↺ try again";
      quiz.appendChild(retry);
      opts.forEach((btn, i) => btn.addEventListener("click", () => {
        if (quiz.classList.contains("answered")) return;
        quiz.classList.add("answered");
        if (!quiz.dataset.result) quiz.dataset.result = i === answer ? "right" : "wrong";
        btn.classList.add(i === answer ? "correct" : "wrong");
        opts[answer].classList.add("correct");
        opts.forEach(o => o.disabled = true);
        updateScore();
      }));
      retry.addEventListener("click", () => {
        quiz.classList.remove("answered");
        opts.forEach(o => { o.disabled = false; o.classList.remove("correct", "wrong"); });
      });
    });
    updateScore();
  }

  function initSorters() {
    document.querySelectorAll(".sorter").forEach(sorter => {
      const nameA = sorter.dataset.a || "A", nameB = sorter.dataset.b || "B";
      const chips = [...sorter.querySelectorAll(".chip")];
      const legend = document.createElement("div");
      legend.className = "legend";
      legend.innerHTML = `<span>dashed = unsorted</span><span class="a">● ${nameA}</span><span class="b">● ${nameB}</span>`;
      sorter.querySelector(".chips").before(legend);

      const actions = document.createElement("div");
      actions.className = "actions";
      actions.innerHTML = `<button class="btn" type="button">Check</button><button class="btn ghost" type="button">Reset</button>`;
      const feedback = document.createElement("div");
      feedback.className = "feedback";
      sorter.append(actions, feedback);
      const [check, reset] = actions.querySelectorAll("button");

      const cycle = { "": "a", a: "b", b: "a" };
      chips.forEach(chip => {
        chip.type = "button";
        chip.dataset.placed = "";
        chip.addEventListener("click", () => {
          chip.dataset.placed = cycle[chip.dataset.placed];
          chip.classList.remove("ok", "no");
        });
      });
      check.addEventListener("click", () => {
        const unplaced = chips.filter(c => !c.dataset.placed);
        if (unplaced.length) { feedback.textContent = `Sort all chips first. ${unplaced.length} still unsorted.`; return; }
        const wrong = [];
        chips.forEach(c => {
          const ok = c.dataset.placed === c.dataset.bucket;
          c.classList.toggle("ok", ok); c.classList.toggle("no", !ok);
          if (!ok) wrong.push(c);
        });
        if (!wrong.length) { feedback.innerHTML = `<strong>All ${chips.length} correct.</strong>`; return; }
        feedback.innerHTML = `<strong>${chips.length - wrong.length} / ${chips.length} correct.</strong> Hints for the ones marked ✗:<ul>` +
          wrong.map(c => `<li><code>${c.textContent}</code>: ${c.dataset.why || ""}</li>`).join("") + `</ul>`;
      });
      reset.addEventListener("click", () => {
        chips.forEach(c => { c.dataset.placed = ""; c.classList.remove("ok", "no"); });
        feedback.textContent = "";
      });
    });
  }

  document.addEventListener("DOMContentLoaded", () => { initQuizzes(); initSorters(); });
})();
