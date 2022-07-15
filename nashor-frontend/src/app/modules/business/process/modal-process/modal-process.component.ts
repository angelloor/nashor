import {
  ActionAngelConfirmation,
  AngelConfirmationService,
} from '@angel/services/confirmation';
import { OverlayRef } from '@angular/cdk/overlay';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppInitialData, MessageAPI } from 'app/core/app/app.type';
import { LayoutService } from 'app/layout/layout.service';
import { NotificationService } from 'app/shared/notification/notification.service';
import { Subject, takeUntil } from 'rxjs';
import { FlowVersionLevelService } from '../../flow/flow-version/flow-version-level/flow-version-level.service';
import { FlowVersionLevel } from '../../flow/flow-version/flow-version-level/flow-version-level.types';
import { LevelProfile } from '../../level-profile/level-profile.types';
import { official } from '../../official/official.data';
import { Official } from '../../official/official.types';
import { ProcessService } from '../process.service';
import { Process } from '../process.types';
import { ModalProcessService } from './modal-process.service';

@Component({
  selector: 'app-modal-process',
  templateUrl: './modal-process.component.html',
})
export class ModalProcessComponent implements OnInit {
  nameEntity: string = 'Proceso';
  private data!: AppInitialData;

  process!: Process;
  processForm!: FormGroup;

  flowVersionLevel!: FlowVersionLevel[];
  levelProfile!: LevelProfile;

  private _tagsPanelOverlayRef!: OverlayRef;
  private _unsubscribeAll: Subject<any> = new Subject<any>();
  /**
   * isOpenModal
   */
  isOpenModal: boolean = false;
  /**
   * isOpenModal
   */
  official: Official = official;

  /**
   * Constructor
   */
  constructor(
    private _store: Store<{ global: AppInitialData }>,
    private _changeDetectorRef: ChangeDetectorRef,
    private _processService: ProcessService,
    private _formBuilder: FormBuilder,
    private _activatedRoute: ActivatedRoute,
    private _notificationService: NotificationService,
    private _angelConfirmationService: AngelConfirmationService,
    private _layoutService: LayoutService,
    private _modalProcessService: ModalProcessService,
    private _flowVersionLevelService: FlowVersionLevelService
  ) {}

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Lifecycle hooks
	  /** ----------------------------------------------------------------------------------------------------- */

  /**
   * On init
   */
  ngOnInit(): void {
    /**
     * isOpenModal
     */
    this._layoutService.isOpenModal$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_isOpenModal: boolean) => {
        this.isOpenModal = _isOpenModal;
      });
    /**
     * isOpenModal
     */
    /**
     * Subscribe to user changes of state
     */
    this._store.pipe(takeUntil(this._unsubscribeAll)).subscribe((state) => {
      this.data = state.global;
      if (this.data.official) {
        this.official = this.data.official;
      }
    });
    /**
     * Create the process form
     */
    this.processForm = this._formBuilder.group({
      id_process: [''],
      process_type: [''],
      official: [''],
      flow_version: [''],
      number_process: [''],
      date_process: [''],
      generated_task: [''],
      finalized_process: [''],
    });
    /**
     * Get the process
     */
    this._processService.process$
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((process: Process) => {
        /**
         * Get the process
         */
        this.process = process;
        this._flowVersionLevelService
          .byFlowVersionRead(this.process.flow_version.id_flow_version)
          .pipe(takeUntil(this._unsubscribeAll))
          .subscribe((_flowVersionLevel: FlowVersionLevel[]) => {
            this.flowVersionLevel = _flowVersionLevel;

            this.levelProfile = this.getLevelProfile(this.flowVersionLevel);
          });
        /**
         * Patch values to the form
         */
        this.patchForm();
        /**
         * Mark for check
         */
        this._changeDetectorRef.markForCheck();
      });
  }
  /**
   * getLevelProfile
   * @param flowVersionLevel
   * @returns id_level_profile
   */
  getLevelProfile(_flowVersionLevel: FlowVersionLevel[]): LevelProfile {
    return _flowVersionLevel.find((item) => item.position_level >= 1)!.level
      ?.level_profile!;
  }
  /**
   * Pacth the form with the information of the database
   */
  patchForm(): void {
    this.processForm.patchValue(this.process);
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
    /**
     * Dispose the overlays if they are still on the DOM
     */
    if (this._tagsPanelOverlayRef) {
      this._tagsPanelOverlayRef.dispose();
    }
  }

  /** ----------------------------------------------------------------------------------------------------- */
  /** @ Public methods
	  /** ----------------------------------------------------------------------------------------------------- */
  /**
   * Update the process
   */
  updateProcess(): void {
    this._angelConfirmationService
      .open({
        title: 'Generar tarea',
        message:
          '¿Estás seguro de que deseas generar la tarea? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          if (this.official.id_official != '0') {
            const id_user_ = this.data.user.id_user;
            let process = this.processForm.getRawValue();
            /**
             * Delete whitespace (trim() the atributes type string)
             */
            process = {
              ...process,
              id_user_: parseInt(id_user_),
              id_process: parseInt(process.id_process),
              process_type: {
                id_process_type: parseInt(process.process_type.id_process_type),
              },
              // Se envia el id_official seleccionado para asignar en la tarea
              official: {
                id_official: parseInt(this.official.id_official),
              },
              flow_version: {
                id_flow_version: parseInt(process.flow_version.id_flow_version),
              },
              generated_task: true,
            };

            /**
             * Update
             */
            this._processService
              .update(process)
              .pipe(takeUntil(this._unsubscribeAll))
              .subscribe({
                next: (_process: Process) => {
                  if (_process) {
                    this._notificationService.success(
                      'Proceso actualizado correctamente'
                    );
                  } else {
                    this._notificationService.error(
                      '¡Error interno!, consulte al administrador.'
                    );
                  }
                },
                error: (error: { error: MessageAPI }) => {
                  this._notificationService.error(
                    !error.error
                      ? '¡Error interno!, consulte al administrador.'
                      : !error.error.description
                      ? '¡Error interno!, consulte al administrador.'
                      : error.error.description
                  );
                },
              });
          } else {
            this._notificationService.error(
              '¡Error interno!, consulte al administrador. (No se encontró el id_official)'
            );
          }
        }
      });
  }
  /**
   * Delete the process
   */
  deleteProcess(): void {
    this._angelConfirmationService
      .open({
        title: 'Eliminar proceso',
        message:
          '¿Estás seguro de que deseas eliminar esta proceso? ¡Esta acción no se puede deshacer!',
      })
      .afterClosed()
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((confirm: ActionAngelConfirmation) => {
        if (confirm === 'confirmed') {
          const id_user_ = this.data.user.id_user;
          const id_process = this.process.id_process;
          /**
           * Delete the process
           */
          this._processService
            .delete(id_user_, id_process)
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe({
              next: (response: boolean) => {
                if (response) {
                  /**
                   * Return if the process wasn't deleted...
                   */
                  this._notificationService.success(
                    'Proceso eliminada correctamente'
                  );
                  /**
                   * Get the current activated route
                   */
                  let route = this._activatedRoute;
                  while (route.firstChild) {
                    route = route.firstChild;
                  }
                  this.closeModalProcess();
                } else {
                  this._notificationService.error(
                    '¡Error interno!, consulte al administrador.'
                  );
                }
              },
              error: (error: { error: MessageAPI }) => {
                this._notificationService.error(
                  !error.error
                    ? '¡Error interno!, consulte al administrador.'
                    : !error.error.description
                    ? '¡Error interno!, consulte al administrador.'
                    : error.error.description
                );
              },
            });
          /**
           * Mark for check
           */
          this._changeDetectorRef.markForCheck();
        }
        this._layoutService.setOpenModal(false);
      });
  }
  closeModalProcess(): void {
    this._modalProcessService.closeModalProcess();
  }
}
