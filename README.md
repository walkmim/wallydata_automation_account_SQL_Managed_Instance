## Aqui teremos scripts para automatizar manutenção em SQL Managed Instance compatíveis para implementar no Azure Automation Account


### Scale Up Down

<p>Esta automação permite que você realize scale de recurso tanto para mais quanto para menos.</p>
<p>Oriento que estude sobre as limitações de acordo com o seu ambiente pois existe matriz de compatibilidade de recursos para realizar scale up e down. Abaixo uma matriz que montei baseado na documentação Microsoft que pode te ajudar:</p>

![Matriz SQL Managed Instance Configuration!](/Scale-Up-Down/MatrizSQLManagedInstanceConfiguration.jpeg "MatrizSQLManagedInstanceConfiguration")

<ul>
<li>Documentação Microsoft de referência:</li>
  <ul>
<li>[Overview of Azure SQL Managed Instance resource limits](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/resource-limits?view=azuresql)</li>
<li>[Overview of Azure SQL Managed Instance management operations](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/management-operations-overview?view=azuresql)</li>
<li>[Managed instance update steps](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/management-operations-overview?view=azuresql#managed-instance-update-steps)</li>
<li>[Set-AzSqlInstance](https://learn.microsoft.com/en-us/powershell/module/az.sql/set-azsqlinstance?view=azps-11.5.0)</li>
<li>[Get-AzSqlInstance](https://learn.microsoft.com/en-us/powershell/module/az.sql/get-azsqlinstance?view=azps-11.5.0)</li>
</ul>
</ul>
