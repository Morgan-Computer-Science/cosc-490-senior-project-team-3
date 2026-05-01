ITEMS_PER_PAGE = 20;

const page_start = document.getElementById('page-start');
const page_prev = document.getElementById('page-previous');

const page_1 = document.getElementById('page-1');
const page_2 = document.getElementById('page-2');
const page_3 = document.getElementById('page-3');

// const page_end_num = document.getElementById('page-end-numeric');

const page_next = document.getElementById('page-next');
const page_end = document.getElementById('page-end');

class Panel {
    loaded_table = null;
    sort_order = false;
    sort_field = null;
    offset = 0;

    sort_element = null;
    count = 0;

    fields = [];

    constructor(table_name) {
        this.load_table(table_name);
        this.update_table();
    }

    async fetch_data() {
        const response = await fetch(`/api/v1/records?table=${this.loaded_table}&offset=${this.offset}&n=${ITEMS_PER_PAGE}&sort_by=${this.sort_field}&sort_order=${this.sort_order}`);

        const data = await response.json();

        return data;
    }

    set_sort(field) {
        if (this.sort_field == field) {
            // this.sort_order = this.sort_order == 'ascending' ? 'descending' : 'ascending';
            this.sort_order = !this.sort_order;
        } else {
            this.sort_field = field;
            this.sort_order = true;
        }
    }

    async load_table(table_name) {
        this.loaded_table = table_name;
        this.sort_field = null;

        const response = await fetch(`/api/v1/table_info?table=${this.loaded_table}`);

        const schema = await response.json();

        const table_title = document.getElementById('table-title');
        const table_meta = document.getElementById('table-meta');

        table_title.textContent = this.loaded_table;
        table_meta.textContent = `${schema.count} rows · ${schema.fields.length} cols`;

        this.count = schema.count;

        const fields_row = document.getElementById('fields-row');

        fields_row.innerHTML = '<th class="checkbox"><div class="checkbox-box" id="selectAll"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg></div></th>';

        for (const column of schema.fields) {
            const field = column.name;
            const type = column.type;

            const field_element = document.createElement('th');

            field_element.innerHTML = `
                <div class="th-inner">
                    ${field} <span class="type">${type}</span>
                    <svg xmlns="http://www.w3.org/2000/svg" style="display: none" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
                </div>
            `;

            const panel = this;

            field_element.onclick = function() {
                if (panel.sort_element) {
                    panel.sort_element.classList.remove('sorted');

                    panel.sort_element.querySelector('svg').style.display = 'none';
                }

                panel.set_sort(field);
                panel.update_table();

                field_element.classList.toggle('sorted', panel.sort_field == field);
                field_element.querySelector('svg').style.display = panel.sort_field == field ? 'block' : 'none';

                panel.sort_element = field_element;
            }

            fields_row.append(field_element);
        }

        const padding_element = document.createElement('th');

        padding_element.style.width = '40px';
        fields_row.append(padding_element);

        this.update_table();
    }

    async update_table() {
        const data = await this.fetch_data();
        
        const field_classes = ['id', 'email'];

        // update header

        const table_body = document.getElementById('table-body');

        // update row

        table_body.innerHTML = '';

        for (const row of data.rows) {
            const row_element = document.createElement('tr');

            row_element.innerHTML = `
                <td class="checkbox">
                    <div class="checkbox-box">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                    </div>
                </td>
            `;

            for (const field of data.fields) {
                const value = row[field]

                const element = document.createElement('td');
                
                element.classList.add(field_classes.includes(field) ? field : 'mono');

                element.textContent = value;

                row_element.append(element);
            }

            row_element.innerHTML += '<td style="width: 40px;"></td>';

            table_body.append(row_element);
        }

        table_body.querySelectorAll("tr").forEach(tr => {
            tr.addEventListener("click", (e) => {
                if (e.target.closest(".checkbox-box") || e.target.closest(".row-actions") || e.target.closest(".fk-link")) return;
                openDrawer(parseInt(tr.dataset.index));
            });
        });

        // checkbox clicks
        table_body.querySelectorAll(".checkbox-box").forEach(cb => {
            cb.addEventListener("click", (e) => {
                e.stopPropagation();
                cb.classList.toggle("checked");
                const tr = cb.closest("tr");
                tr.classList.toggle("selected", cb.classList.contains("checked"));
                updateSelectedCount();
            });
        });

        // update footer
        
        const load_range = document.getElementById('load-range');

        load_range.innerHTML = `
            <span>showing</span>
            <strong style="color: var(--stone-300);">${this.offset + 1}-${Math.min(this.count, this.offset + ITEMS_PER_PAGE)}</strong>
            <span>of</span>
            <strong style="color: var(--stone-300);">${this.count}</strong>
        `

        // update pagination
        const current_page = this.get_page();
        const max_pages = this.get_page_count();

        page_start.disabled = (current_page === 1);
        page_prev.disabled = (current_page === 1);

        page_next.disabled = (current_page === max_pages);
        page_end.disabled = (current_page === max_pages);

        if (current_page == 1) {
            page_1.textContent = current_page;
            page_2.textContent = current_page + 1;
            page_3.textContent = current_page + 2;

            page_1.classList.toggle('active', true);
            page_2.classList.toggle('active', false);
            page_3.classList.toggle('active', false);
        } else if (current_page == max_pages) {
            page_1.textContent = max_pages - 2;
            page_2.textContent = max_pages - 1;
            page_3.textContent = max_pages;

            page_1.classList.toggle('active', false);
            page_2.classList.toggle('active', false);
            page_3.classList.toggle('active', true);
        } else {
            page_1.textContent = current_page - 1;
            page_2.textContent = current_page;
            page_3.textContent = current_page + 1;

            page_1.classList.toggle('active', false);
            page_2.classList.toggle('active', true);
            page_3.classList.toggle('active', false);
        }
    }

    get_page() {
        return Math.ceil(this.offset / ITEMS_PER_PAGE) + 1;
    }

    get_page_count() {
        Math.ceil(this.count / ITEMS_PER_PAGE) + 1;
    }

    set_page(page_num) {
        const offset = (page_num - 1) * ITEMS_PER_PAGE;

        if (offset >= this.count) {
            return;
        }

        this.offset = offset;

        this.update_table()
    }
}

const panel = new Panel('users');

page_start.onclick = () => {
    panel.set_page(1)
}

page_prev.onclick = () => {
    panel.set_page(panel.get_page() - 1);
}

function pagination_num(event) {
    panel.set_page(parseInt(event.currentTarget.textContent))
}

page_1.onclick = pagination_num;
page_2.onclick = pagination_num;
page_3.onclick = pagination_num;

page_next.onclick = () => {
    panel.set_page(panel.get_page() + 1);
}

page_end.onclick = () => {
    panel.set_page(panel.get_page_count());
}

// render sidebar
// const tables = ['users', 'advisors', 'courses', ]

document.querySelectorAll(".nav-item[data-table]").forEach(btn => {
    btn.addEventListener("click", () => {

        // remove active from all buttons
        document.querySelectorAll(".nav-item").forEach(b => b.classList.remove("active"));

        // make clicked button active
        btn.classList.add("active");

        const table = btn.dataset.table;

        console.log(table);

        panel.load_table(table);
    });
});