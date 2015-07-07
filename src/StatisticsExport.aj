import view.GUI;

public privileged aspect StatisticsExport {

	declare precedence: StatisticsExport, GraphExport, PdfExport;
	
}
