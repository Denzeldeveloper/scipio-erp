import org.ofbiz.base.util.UtilProperties;

import com.ilscipio.scipio.ce.demoSuite.dataGenerator.util.DemoSuiteDataGeneratorUtil

context.maxRecords = UtilProperties.getPropertyAsInteger("demosuite", "demosuite.test.data.max.records", 50);

servicesList = new ArrayList();
servicesList = DemoSuiteDataGeneratorUtil.getDemoDataServices(dispatcher);
context.servicesList = servicesList;

