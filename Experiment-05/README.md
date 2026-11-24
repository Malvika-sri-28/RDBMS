# Experiment 5: SQL Views, View Updatability & Recursive CTEs

## 🎯 Aim

To create SQL views for department salary summary and employee hierarchy, test the updatability of views, and implement a recursive CTE to display reporting chains.

---

## 📋 Objectives

- Create a view that summarizes employee salary information department-wise.
- Create an employee hierarchy view using manager relationships.
- Test whether a view is updatable and understand conditions affecting view updates.
- Implement a recursive CTE for displaying hierarchical employee reporting chains.
- Verify the results using `SELECT` queries.

---

## 🗄️ Database Schema & Manager Relationship

The `Employee` table is extended with a self-referencing foreign key `manager_id`:

```sql
ALTER TABLE Employee ADD COLUMN manager_id INT;
ALTER TABLE Employee ADD FOREIGN KEY (manager_id) REFERENCES Employee(emp_id);
```

Department heads have `manager_id IS NULL`, and subordinate employees report hierarchically up to their respective department heads.

---

## 💻 SQL Script

The complete SQL implementation with view definitions, update tests, and recursive CTE is available in:
🔗 **[`Experiment_5.sql`](./Experiment_5.sql)**

---

## 📷 Outputs

View and CTE execution output screenshots are available in:
🔗 **[`output/`](./output/)**

---

## 📊 Result & Conclusion

1. **Department Salary Summary View:** Successfully aggregated key payroll metrics across all 5 departments.
2. **Employee Hierarchy View:** Mapped 30 employees to their immediate reporting managers using a self-referencing `LEFT JOIN`.
3. **View Updatability Constraints:** Verified that views with aggregation and complex joins restrict direct data modifications, requiring updates to target the base table.
4. **Recursive CTE:** Traversed hierarchical relationships to produce complete multi-level reporting paths without procedural loops.
