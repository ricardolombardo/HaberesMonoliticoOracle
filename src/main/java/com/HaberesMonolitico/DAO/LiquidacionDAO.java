package com.HaberesMonolitico.DAO;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;

@Repository
@Transactional
public class LiquidacionDAO {

	@Autowired
    private EntityManager entityManager;

	public void ejecutarSPGenerarTabulados(Long idLiquidacion) {
		System.out.println("Generando los tabulados para la liquidacion "+idLiquidacion);
	    entityManager.createNativeQuery(
	        "BEGIN PRC_GEN_TABULADOS(:idLiquidacion); END;"
	    )
	    .setParameter("idLiquidacion", idLiquidacion)
	    .executeUpdate();
	}
    
	public void ejecutarSPGenerarBasico(Long idLiquidacion) {
		System.out.println("Generando los basicos para la liquidacion "+idLiquidacion);
	    entityManager
	        .createNativeQuery("BEGIN PRC_GEN_BASICO(:idLiquidacion); END;")
	        .setParameter("idLiquidacion", idLiquidacion)
	        .executeUpdate();
	}
    
	public void ejecutarSPGenerarTitulo(Long idLiquidacion) {
		System.out.println("Generando lo ingreso por tirulos para la liquidacion "+idLiquidacion);
	    entityManager
	        .createNativeQuery("BEGIN PRC_GEN_TITULO(:idLiquidacion); END;")
	        .setParameter("idLiquidacion", idLiquidacion)
	        .executeUpdate();
	}
    
    @SuppressWarnings("unchecked")
	public List<Object[]> generarReporteLiquidaciones(
            Integer anioDesde, Integer mesDesde, Integer anioHasta, Integer mesHasta) {

        return entityManager
            .createNativeQuery("EXEC PRC_GEN_RPT_LIQ :anioDesde, :mesDesde, :anioHasta, :mesHasta")
            .setParameter("anioDesde", anioDesde)
            .setParameter("anioHasta", anioHasta)
            .setParameter("mesDesde", mesDesde)
            .setParameter("mesHasta", mesHasta)
            .getResultList();
    }
	
	
    @SuppressWarnings("unchecked")
	public List<Object[]> generarReporteDetalladoLiquidaciones(
            Integer anioDesde, Integer mesDesde, Integer anioHasta, Integer mesHasta) {

        return entityManager
            .createNativeQuery("PRC_GEN_RPT_LIQ_DET :anioDesde, :mesDesde, :anioHasta, :mesHasta")
            .setParameter("anioDesde", anioDesde)
            .setParameter("anioHasta", anioHasta)
            .setParameter("mesDesde", mesDesde)
            .setParameter("mesHasta", mesHasta)
            .getResultList();
    }


    
}
