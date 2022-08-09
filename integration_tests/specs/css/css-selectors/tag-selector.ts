describe("css tag selector", () => {
  it("001", async () => {
    const style = <style>{`p { color: green; }`}</style>;
    const p1 = <p>This sentence must be green.</p>;
    const p2 = <p>This sentence must be green.</p>;
    const p3 = <p>This sentence must be green.</p>;
    const p4 = <p>This sentence must be green.</p>;
    const p5 = <p>This sentence must be green.</p>;
    document.head.appendChild(style);
    document.body.appendChild(p1);
    document.body.appendChild(p2);
    document.body.appendChild(p3);
    document.body.appendChild(p4);
    document.body.appendChild(p5);
    await snapshot();
  });

  it("002", async () => {
    const style = <style>{`div, blockquote { color: green; }`}</style>;
    const p = <p>Test passes if the "Filler Text" below is green.</p>;
    const blockquote = <blockquote>Filler Text</blockquote>;
    const div = <div>Filler Text</div>;
    document.head.appendChild(style);
    document.body.appendChild(p);
    document.body.appendChild(blockquote);
    document.body.appendChild(div);
    await snapshot();
  });

  it("003", async () => {
    const style = <style>{`DIV { color: green; }`}</style>;
    const div = <div>Filler Text</div>;
    document.head.appendChild(style);
    document.body.appendChild(div);
    await snapshot();
  });

  fit("004", async () => {
    const style = <style>{`body * {
        margin: 1em 0;
        font: inherit;
        display: block;
        color: white;
        background: green;
      }`}</style>;
     const e1 = <p>This text should be green. (element)</p>;
     const e2 =<div>This text should be green. (class)</div>
     const e3 =<div>This text should be green. (id)</div>
     const e4 =<div>This text should be green. (child)</div>
     const e5 =<div>This text should be green. (descendant)</div>
     const e6 =<blockquote>This text should be green. (sibling)</blockquote>
     const e7 =<div>This text should be green. (attribute)</div>
    document.head.appendChild(style);
    document.body.appendChild(e1);
    document.body.appendChild(e2);
    document.body.appendChild(e3);
    document.body.appendChild(e4);
    document.body.appendChild(e5);
    document.body.appendChild(e6);
    document.body.appendChild(e7);
    await snapshot();
  });
});
