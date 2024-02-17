from datetime import datetime

from flask import Flask, request, render_template, redirect, url_for
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///goodsman.db'
db = SQLAlchemy(app)


class Invoice(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    invoice_number = db.Column(db.String(10), unique=True, nullable=False)
    invoice_date = db.Column(db.Date, nullable=True)
    customer_name = db.Column(db.String(100), nullable=False)
    total_amount = db.Column(db.Float, nullable=False, default=0.0)
    line_items = db.relationship('InvoiceLineItem', backref='invoice', lazy=True, cascade='all, delete-orphan')


class InvoiceLineItem(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    item_name = db.Column(db.String(100), nullable=False)
    quantity = db.Column(db.Integer, default=1)
    unit_price = db.Column(db.Float, nullable=False)
    sub_total = db.column_property(quantity * unit_price)
    tax = db.Column(db.Integer, default=0)
    total = db.column_property(sub_total + (sub_total * tax / 100))
    invoice_id = db.Column(db.Integer, db.ForeignKey('invoice.id'), nullable=False)


with app.app_context():
    db.create_all()


@app.route("/")
def index():
    invoices = Invoice.query.all()
    return render_template('index.html', invoices=invoices)


@app.route('/create_invoice', methods=['POST'])
def create_invoice():
    invoice_number = request.form['invoice_number']
    customer_name = request.form['customer_name']
    invoice_date_str = request.form['invoice_date']
    # Convert the string to a date object
    invoice_date = datetime.strptime(invoice_date_str, '%Y-%m-%d').date()
    invoice = Invoice(invoice_number=invoice_number, customer_name=customer_name, invoice_date=invoice_date)
    db.session.add(invoice)
    db.session.commit()
    return redirect(url_for('index'))


@app.route('/delete_invoice/<int:invoice_id>', methods=['POST'])
def delete_invoice(invoice_id):
    invoice = Invoice.query.get_or_404(invoice_id)
    db.session.delete(invoice)
    db.session.commit()
    return redirect(url_for('index'))


@app.route('/add_line_item/<int:invoice_id>', methods=['POST'])
def add_line_item(invoice_id):
    item_name = request.form['item_name']
    quantity = int(request.form['quantity'])
    unit_price = float(request.form['unit_price'])
    tax = int(request.form['tax'])
    line_item = InvoiceLineItem(item_name=item_name, quantity=quantity, unit_price=unit_price, tax=tax,
                                invoice_id=invoice_id)
    db.session.add(line_item)
    db.session.commit()

    # Update the total amount of the invoice
    update_invoice_total(invoice_id)
    return redirect(url_for('index'))


@app.route('/delete_line_item/<int:line_item_id>', methods=['POST'])
def delete_line_item(line_item_id):
    line_item = InvoiceLineItem.query.get_or_404(line_item_id)
    invoice_id = line_item.invoice_id
    db.session.delete(line_item)
    db.session.commit()

    # Update the total amount of the invoice
    update_invoice_total(invoice_id)

    return redirect(url_for('index'))


# Helper function to update the total amount of the invoice
def update_invoice_total(invoice_id):
    invoice = Invoice.query.get_or_404(invoice_id)
    total_amount = sum(line_item.total for line_item in invoice.line_items)
    invoice.total_amount = total_amount
    db.session.commit()


if __name__ == "__main__":
    app.run()
