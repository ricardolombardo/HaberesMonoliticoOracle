package com.HaberesMonolitico.DAO;

import java.util.Hashtable;
import java.util.Map;
import java.util.StringJoiner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;

@Repository
public class GenericDAOExecutor {
	
	@Autowired
    private EntityManager entityManager;
	
	@Transactional
	public void ejecutarSP(String sp, Hashtable<String, Object> params) {

	    StringJoiner joiner = new StringJoiner(", ");
	    for (String key : params.keySet()) {
	        joiner.add(":" + key);
	    }

	    // Construir SQL Oracle PL/SQL
	    String sql = "BEGIN " + sp + "(" + joiner.toString() + "); END;";

	    Query query = entityManager.createNativeQuery(sql);

	    // Setear parámetros
	    System.out.print(sql + " ");
	    for (Map.Entry<String, Object> entry : params.entrySet()) {
	        System.out.print(entry.getKey() + " " + entry.getValue() + " ");
	        query.setParameter(entry.getKey(), entry.getValue());
	    }
	    System.out.println();

	    query.executeUpdate();
	}

}
